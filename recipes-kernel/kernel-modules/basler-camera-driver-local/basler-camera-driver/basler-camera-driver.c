//copy of ov5640 mainline 4.20
/*
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 */

#include <linux/clk.h>
#include <linux/clk-provider.h>
#include <linux/clkdev.h>
#include <linux/ctype.h>
#include <linux/device.h>
#include <linux/of_gpio.h>
#include <linux/of_graph.h>
#include <linux/gpio/consumer.h>
#include <linux/init.h>
#include <linux/module.h>
#include <linux/of_device.h>
#include <linux/regulator/consumer.h>
#include <linux/slab.h>
#include <linux/types.h>
#include <linux/delay.h>
#include <linux/i2c.h>
#include <linux/kernel.h>
#include <linux/v4l2-mediabus.h>
#include <media/v4l2-async.h>
#include <media/v4l2-ctrls.h>
#include <media/v4l2-device.h>
#include <media/v4l2-fwnode.h>
#include <media/v4l2-subdev.h>
#include "basler-camera-driver.h"

/*global variable*/
static struct register_access ra_tmp;
static struct register_access *ra_tmp_p = &ra_tmp;

#define SENSOR_NAME "basler-camera"
#define XCLK_MIN  5000000
#define XCLK_MAX 640000000

/*
 * ABRM register offsets
 *
 */
#define ABRM_GENCP_VERSION			0x0
#define ABRM_MANUFACTURER_NAME		0x4
#define ABRM_MODEL_NAME				0x44
#define ABRM_FAMILY_NAME			0x84
#define ABRM_DEVICE_VERSION			0xC4
#define ABRM_MANUFACTURER_INFO		0x104
#define ABRM_SERIAL_NUMBER			0x144
#define ABRM_USER_DEFINED_NAME		0x184
#define ABRM_DEVICE_CAPABILITIES	0x1C4

/*
 * ABRM register bits
 *
 */
#define ABRM_DEVICE_CAPABILITIES_USER_DEFINED_NAMES_SUPPORT		0x1
#define ABRM_DEVICE_CAPABILITIES_STRING_ENCODING				0x0f
#define ABRM_DEVICE_CAPABILITIES_FAMILY_NAME					0x100


/*
 * Maximum read i2c burst
 *
 * TODO: To be replace by a register call of SBRM
 *
 */
#define I2C_MAXIMUM_READ_BURST	8

static int basler_camera_s_ctrl(struct v4l2_ctrl *ctrl);
static int basler_camera_g_volatile_ctrl(struct v4l2_ctrl *ctrl);
static int basler_camera_validate(const struct v4l2_ctrl *ctrl, u32 idx, union v4l2_ctrl_ptr ptr );
static void basler_camera_init(const struct v4l2_ctrl *ctrl, u32 idx, union v4l2_ctrl_ptr ptr );
static bool basler_camera_equal(const struct v4l2_ctrl *ctrl, u32 idx, union v4l2_ctrl_ptr ptr1, union v4l2_ctrl_ptr ptr2 );

struct basler_camera_ctrls {
	struct v4l2_ctrl_handler handler;
	struct {
		struct v4l2_ctrl *access_register;
		struct v4l2_ctrl *basler_device_information;
		struct v4l2_ctrl *basler_interface_version;
		struct v4l2_ctrl *basler_csi_information;
	};
};

struct basler_camera_dev {
	struct i2c_client *i2c_client;
	struct v4l2_subdev sd;
	struct media_pad pad;
	struct clk *xclk; /* system clock to camera sensor */
	u32 xclk_freq;

	struct gpio_desc *reset_gpio;
	struct gpio_desc *pwdn_gpio;

	/* lock to protect all members below */
	struct mutex lock;

	int power_count;
	struct basler_camera_ctrls ctrls;

	struct basler_device_information device_information;
};

/**
 * basler_write_burst - issue a burst I2C message in master transmit mode
 * @client: Handle to slave device
 * @ra_p: Data structure that hold the register address and data that will be written to the slave
 *
 * Returns negative errno, or else the number of bytes written.
 */
static int basler_write_burst(struct i2c_client *client,
		struct register_access *ra_p)
{
	int ret;
	__u16 old_address;

	if (ra_p->data_size > sizeof(ra_p->data)){
		dev_err(&client->dev, "i2c burst array too big, max allowed %d, got %ld\n", sizeof(ra_p->data), ra_p->data_size);
		return -EINVAL;
	}

	old_address = ra_p->address;
	ra_p->address = cpu_to_be16(ra_p->address);

	if (I2CREAD == (ra_p->command | I2CREAD)){
		ra_tmp_p->address = ra_p->address;
		ra_tmp_p->data_size = ra_p->data_size;
		old_address = ra_p->address;
		return ra_p->data_size;
	}
	else if(I2CWRITE == (ra_p->command | I2CWRITE)){
		ret = i2c_master_send(client, (char *)ra_p, ra_p->data_size + sizeof(ra_p->address));

		if(ret)
			ra_p->data_size = ret;

		old_address = ra_p->address;
		return ret;
	}
	else
		return -EPERM;
}

/**
 * basler_read_burst - issue a burst I2C message in master transmit mode
 * @client: Handle to slave device
 * @ra_p: Data structure store the data read from slave
 *
 * Note: Before data can read use basler_write_burst with read command
 *       to send the register address
 *
 * Returns negative errno, or else the number of bytes written.
 */
static int basler_read_burst(struct i2c_client *client,
		struct register_access *ra_p)
{
	int ret;

	ret = i2c_master_send(client, (char *)ra_tmp_p, sizeof(ra_tmp_p->address));
	if (!ret)
		return ret;
	
	ret = i2c_master_recv(client, (char *)ra_p + sizeof(ra_tmp_p->address), ra_tmp_p->data_size);

	if(!ret)
		ra_p->data_size = 0;
	else
		ra_p->data_size = ret;

	return ret;
}


static int basler_read_register_chunk(struct i2c_client* client, __u8* buffer, __u8 buffer_size, __u16 register_address)
{
	int ret = 0;
	__be16 l_register_address = cpu_to_be16(register_address);

	ret = i2c_master_send(client, (char *)&l_register_address, sizeof(l_register_address));
	if (ret < 0)
	{
		pr_err("i2c_master_send() failed %d\n", ret);
		return ret;
	}
	else if (ret != 2)
	{
		pr_err("Failed to write 2 bytes I2C address\n");
		return -EIO;
	}

	ret = i2c_master_recv(client, buffer, buffer_size);
	if (ret < 0)
	{
		pr_err("i2c_master_recv() failed: %d\n", ret);
		return ret;
	}

	return ret;
}

static int basler_read_register(struct i2c_client* client, __u8* buffer, __u8 buffer_size, __u16 register_address)
{
	int ret = 0;
	__u8 l_read_bytes = 0;

	do {
		ret = basler_read_register_chunk(client, (__u8*) buffer + l_read_bytes, (__u8) min(I2C_MAXIMUM_READ_BURST, ((int)buffer_size - l_read_bytes)), (__u16)register_address + l_read_bytes);
		if (ret < 0)
		{
			pr_err("basler_read_register_chunk() failed: %d\n", ret);
			return ret;
		}
		else if (ret == 0)
		{
			pr_err("basler_read_register_chunk() read 0 bytes.\n");
			return -EIO;
		}
		else
		{
			l_read_bytes = l_read_bytes + ret;
		}
	} while (l_read_bytes < buffer_size);

	return l_read_bytes;
}


static int basler_retrieve_device_information(struct i2c_client* client, struct basler_device_information* bdi)
{
	int ret = 0;
	__u64 deviceCapabilities = 0;
	__be64 deviceCapabilitiesBe = 0;
	__u32 gencpVersionBe = 0;

	bdi->_magic = BDI_MAGIC;

	ret = basler_read_register(client, (__u8*) &deviceCapabilitiesBe, sizeof(deviceCapabilitiesBe), ABRM_DEVICE_CAPABILITIES);
	if (ret < 0)
	{
		pr_err("basler_read_register() failed: %d\n", ret);
		return ret;
	}
	else if (ret == sizeof(deviceCapabilitiesBe))
	{
		deviceCapabilities = be64_to_cpu(deviceCapabilitiesBe);
		pr_debug("deviceCapabilities = 0x%lx\n", deviceCapabilities);
		pr_debug("String Encoding = 0x%lx\n", (deviceCapabilities & ABRM_DEVICE_CAPABILITIES_STRING_ENCODING) >> 4);
	}
	else {
		pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
		return -EIO;
	}

	ret = basler_read_register(client, (__u8*) &gencpVersionBe, sizeof(gencpVersionBe), ABRM_GENCP_VERSION);
	if (ret < 0)
	{
		pr_err("basler_read_register() failed: %d\n", ret);
		return ret;
	}
	else if (ret == sizeof(gencpVersionBe))
	{
		bdi->gencpVersion = be32_to_cpu(gencpVersionBe);
		pr_debug("l_gencpVersion = %d.%d\n", (bdi->gencpVersion & 0xffff0000) >> 16, bdi->gencpVersion & 0xffff);
	}
	else {
		pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
		return -EIO;
	}

	ret = basler_read_register(client, bdi->deviceVersion, GENCP_STRING_BUFFER_SIZE, ABRM_DEVICE_VERSION);
	if (ret < 0)
	{
		pr_err("basler_read_register() failed: %d\n", ret);
		return ret;
	}
	else if (ret == GENCP_STRING_BUFFER_SIZE)
	{
		pr_debug("bdi->deviceVersion = %s\n", bdi->deviceVersion);
	}
	else {
		pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
		return -EIO;
	}

	ret = basler_read_register(client, bdi->serialNumber, GENCP_STRING_BUFFER_SIZE, ABRM_SERIAL_NUMBER);
	if (ret < 0)
	{
		pr_err("basler_read_register() failed: %d\n", ret);
		return ret;
	}
	else if (ret == GENCP_STRING_BUFFER_SIZE)
	{
		pr_debug("bdi->serialNumber = %s\n", bdi->serialNumber);
	}
	else {
		pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
		return -EIO;
	}

	ret = basler_read_register(client, bdi->manufacturerName, GENCP_STRING_BUFFER_SIZE, ABRM_MANUFACTURER_NAME);
	if (ret < 0)
	{
		pr_err("basler_read_register() failed: %d\n", ret);
		return ret;
	}
	else if (ret == GENCP_STRING_BUFFER_SIZE)
	{
		pr_debug("bdi->manufacturerName = %s\n", bdi->manufacturerName);
	}
	else {
		pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
		return -EIO;
	}

	ret = basler_read_register(client, bdi->modelName, GENCP_STRING_BUFFER_SIZE, ABRM_MODEL_NAME);
	if (ret < 0)
	{
		pr_err("basler_read_register() failed: %d\n", ret);
		return ret;
	}
	else if (ret == GENCP_STRING_BUFFER_SIZE)
	{
		pr_debug("bdi->modelName = %s\n", bdi->modelName);
	}
	else {
		pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
		return -EIO;
	}

	if (deviceCapabilities & ABRM_DEVICE_CAPABILITIES_FAMILY_NAME)
	{
		ret = basler_read_register(client, bdi->familyName, GENCP_STRING_BUFFER_SIZE, ABRM_FAMILY_NAME);
		if (ret < 0)
		{
			pr_err("basler_read_register() failed: %d\n", ret);
			return ret;
		}
		else if (ret == GENCP_STRING_BUFFER_SIZE)
		{
			pr_debug("bdi->familyName = %s\n", bdi->familyName);
		}
		else {
			pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
			return -EIO;
		}
	}
	else
		pr_notice("ABRM FamilyName not supported\n");

	if (deviceCapabilities & ABRM_DEVICE_CAPABILITIES_USER_DEFINED_NAMES_SUPPORT)
	{
		ret = basler_read_register(client, bdi->userDefinedName, GENCP_STRING_BUFFER_SIZE, ABRM_USER_DEFINED_NAME);
		if (ret < 0)
		{
			pr_err("basler_read_register() failed: %d\n", ret);
			return ret;
		}
		else if (ret == GENCP_STRING_BUFFER_SIZE)
		{
			pr_debug("bdi->userDefinedName = %s\n", bdi->userDefinedName);
		}
		else {
			pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
			return -EIO;
		}
	}
	else
		pr_notice("ABRM UserDefinedName not supported\n");

	ret = basler_read_register(client, bdi->manufacturerInfo, GENCP_STRING_BUFFER_SIZE, ABRM_MANUFACTURER_INFO);
	if (ret < 0)
	{
		pr_err("basler_read_register() failed: %d\n", ret);
		return ret;
	}
	else if (ret == GENCP_STRING_BUFFER_SIZE)
	{
		pr_debug("bdi->manufacturerInfo = %s\n", bdi->manufacturerInfo);
	}
	else {
		pr_err("basler_read_register() not read full buffer = %d bytes\n", ret);
		return -EIO;
	}

	/*
	 * If the strings are in ASCII - print it.
	 */
	if (((deviceCapabilities & ABRM_DEVICE_CAPABILITIES_STRING_ENCODING) >> 4) == 0)
	{
		pr_info("ABRM: Manufactuturer: %s, Model: %s, Device: %s, Serial: %s\n", bdi->manufacturerName, bdi->modelName, bdi->deviceVersion, bdi->serialNumber);
	}

	return 0;
}

static int basler_retrieve_csi_information(struct basler_camera_dev *sensor,
					   struct basler_csi_information* bci)
{
	struct device *dev = &sensor->i2c_client->dev;
	struct v4l2_fwnode_endpoint *endpoint;
	struct device_node *ep;
	int ret;

	/* We need a function that searches for the device that holds
	 * the csi-2 bus information. For now we put the bus information
	 * also into the sensor endpoint itself.
	 */
	ep = of_graph_get_next_endpoint(dev->of_node, NULL);
	if (!ep) {
		dev_err(dev, "missing endpoint node\n");
		return -ENODEV;
	}

	endpoint = v4l2_fwnode_endpoint_alloc_parse(of_fwnode_handle(ep));
	of_node_put(ep);
	if (IS_ERR(endpoint)) {
		dev_err(dev, "failed to parse endpoint\n");
		return PTR_ERR(endpoint);
	}

	if (endpoint->bus_type != V4L2_MBUS_CSI2 ||
	    endpoint->bus.mipi_csi2.num_data_lanes == 0 ||
	    endpoint->nr_of_link_frequencies == 0) {
		dev_err(dev, "missing CSI-2 properties in endpoint\n");
		ret = -ENODATA;
	} else {
		int i;
		bci->max_lane_frequency = endpoint->link_frequencies[0];
		bci->lane_count = endpoint->bus.mipi_csi2.num_data_lanes;
		for (i = 0; i < endpoint->bus.mipi_csi2.num_data_lanes; ++i) {
			bci->lane_assignment[i] = endpoint->bus.mipi_csi2.data_lanes[i];
		}
		ret = 0;
	}

	v4l2_fwnode_endpoint_free(endpoint);
	return ret;
}

static inline struct basler_camera_dev *to_basler_camera_dev(struct v4l2_subdev *sd)
{
	return container_of(sd, struct basler_camera_dev, sd);
}

static inline struct v4l2_subdev *ctrl_to_sd(struct v4l2_ctrl *ctrl)
{
	return &container_of(ctrl->handler, struct basler_camera_dev,
			     ctrls.handler)->sd;
}

/**
 * basler_camera_set_fmt - set format of the camera
 *
 * Note: Will be done in user space
 *
 * Returns always zero
 */
static int basler_camera_set_fmt(struct v4l2_subdev *sd,
			  struct v4l2_subdev_pad_config *cfg,
			  struct v4l2_subdev_format *format)
{
	return 0;
}

/**
 * basler_camera_s_stream - start camera streaming
 *
 * Note: Will be done in user space
 *
 * Returns always zero
 */
static int basler_camera_s_stream(struct v4l2_subdev *sd, int enable)
{
	return 0;
}

static int basler_camera_s_power(struct v4l2_subdev *sd, int on)
{
	struct basler_camera_dev *sensor = to_basler_camera_dev(sd);

	mutex_lock(&sensor->lock);

	/* Update the power count. */
	sensor->power_count += on ? 1 : -1;
	WARN_ON(sensor->power_count < 0);

	mutex_unlock(&sensor->lock);

	return 0;
}

static const struct v4l2_subdev_core_ops basler_camera_core_ops = {
	.s_power = basler_camera_s_power,
};

static const struct v4l2_subdev_video_ops basler_camera_video_ops = {
	.s_stream = basler_camera_s_stream,
};

static const struct v4l2_subdev_pad_ops basler_camera_pad_ops = {
	.set_fmt = basler_camera_set_fmt,
};

static const struct v4l2_subdev_ops basler_camera_subdev_ops = {
	.core = &basler_camera_core_ops,
	.video = &basler_camera_video_ops,
	.pad = &basler_camera_pad_ops,
};

static const struct v4l2_ctrl_ops basler_camera_ctrl_ops = {
	.g_volatile_ctrl = basler_camera_g_volatile_ctrl,
	.s_ctrl = basler_camera_s_ctrl,
};

static const struct v4l2_ctrl_type_ops basler_camera_ctrl_type_ops = {
	.validate = basler_camera_validate,
	.init = basler_camera_init,
	.equal = basler_camera_equal,
};

/**
 * basler_camera_validate 
 *
 * Note: Not needed by access-register control
 *
 * Returns always zero
 */
static int basler_camera_validate(const struct v4l2_ctrl *ctrl, u32 idx, union v4l2_ctrl_ptr ptr )
{
	return 0;
}

/**
 * basler_camera_init 
 *
 * Note: Not needed by access-register control
 *
 */
static void basler_camera_init(const struct v4l2_ctrl *ctrl, u32 idx, union v4l2_ctrl_ptr ptr )
{
}

/**
 * basler_camera_equal 
 *
 * Note: Not needed by access-register control
 *
 * Returns always zero
 */
static bool basler_camera_equal(const struct v4l2_ctrl *ctrl, u32 idx, union v4l2_ctrl_ptr ptr1, union v4l2_ctrl_ptr ptr2 )
{
	return 0;
}

static const struct v4l2_ctrl_config ctrl_access_register = {
	.ops = &basler_camera_ctrl_ops,
	.type_ops = &basler_camera_ctrl_type_ops,
	.id = V4L2_CID_BASLER_ACCESS_REGISTER,
	.name = "basler-access-register",
	.type = V4L2_CTRL_TYPE_U32+1, //V4L2_CTRL_COMPOUND_TYPES = (V4L2_CTRL_TYPE_U8 || V4L2_CTRL_TYPE_U16 || V4L2_CTRL_TYPE_U32);
	.flags = V4L2_CTRL_FLAG_EXECUTE_ON_WRITE | V4L2_CTRL_FLAG_VOLATILE,
	.step = 1,
	.dims = {1},
	.elem_size = sizeof(struct register_access),
};

static const struct v4l2_ctrl_config ctrl_basler_device_information = {
	.ops = &basler_camera_ctrl_ops,
	.type_ops = &basler_camera_ctrl_type_ops,
	.id = V4L2_CID_BASLER_DEVICE_INFORMATION,
	.name = "basler-device-information",
	.type = V4L2_CTRL_TYPE_U32+1, //V4L2_CTRL_COMPOUND_TYPES = (V4L2_CTRL_TYPE_U8 || V4L2_CTRL_TYPE_U16 || V4L2_CTRL_TYPE_U32);
	.flags = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_VOLATILE,
	.step = 1,
	.dims = {1},
	.elem_size = sizeof(struct basler_device_information),
};

static const struct v4l2_ctrl_config ctrl_basler_interface_version = {
	.ops = &basler_camera_ctrl_ops,
	.type_ops = &basler_camera_ctrl_type_ops,
	.id = V4L2_CID_BASLER_INTERFACE_VERSION,
	.name = "basler-interface-version",
	.type = V4L2_CTRL_TYPE_INTEGER,
	.flags = V4L2_CTRL_FLAG_READ_ONLY,
	.min = 0x0,
	.max = 0xffffffff,
	.def = (BASLER_INTERFACE_VERSION_MAJOR << 16) | BASLER_INTERFACE_VERSION_MINOR,
	.step = 1,
};

static const struct v4l2_ctrl_config ctrl_basler_csi_information = {
	.ops = &basler_camera_ctrl_ops,
	.type_ops = &basler_camera_ctrl_type_ops,
	.id = V4L2_CID_BASLER_CSI_INFORMATION,
	.name = "basler-csi-information",
	.type = V4L2_CTRL_TYPE_U32+1, //V4L2_CTRL_COMPOUND_TYPES = (V4L2_CTRL_TYPE_U8 || V4L2_CTRL_TYPE_U16 || V4L2_CTRL_TYPE_U32);
	.flags = V4L2_CTRL_FLAG_READ_ONLY | V4L2_CTRL_FLAG_VOLATILE,
	.step = 1,
	.dims = {1},
	.elem_size = sizeof(struct basler_csi_information),
};


static int basler_camera_s_ctrl(struct v4l2_ctrl *ctrl)
{
	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
	struct basler_camera_dev *sensor = to_basler_camera_dev(sd);
	struct i2c_client *client = sensor->i2c_client;
	int ret;
	struct register_access *fp_ra_new;

	switch (ctrl->id) {
	case V4L2_CID_BASLER_ACCESS_REGISTER:

		fp_ra_new = (struct register_access*) ctrl->p_new.p;

		if (ctrl->elem_size == sizeof(struct register_access))
		{
			if(basler_write_burst(client, fp_ra_new))
				ret = 0;
			else
				ret = -EIO;
		}
		else {
			ret = -ENOMEM;
		}

		break;
	default:
		ret = -EINVAL;
		break;
	}

	return ret;
}

static int basler_camera_g_volatile_ctrl(struct v4l2_ctrl *ctrl)
{
	struct v4l2_subdev *sd = ctrl_to_sd(ctrl);
	struct basler_camera_dev *sensor = to_basler_camera_dev(sd);
	struct i2c_client *client = sensor->i2c_client;
	int ret;
	struct register_access *fp_ra_new = NULL;
	struct basler_device_information* l_bdi = NULL;

	switch (ctrl->id) {
	case V4L2_CID_BASLER_ACCESS_REGISTER:

		fp_ra_new = (struct register_access*) ctrl->p_new.p;

		if (ctrl->elem_size == sizeof(struct register_access))
		{
			if(basler_read_burst(client, fp_ra_new))
				ret = 0;
			else
				ret = -EIO;
		}
		else {
			ret = -ENOMEM;
		}
		break;

	case V4L2_CID_BASLER_DEVICE_INFORMATION:

		l_bdi = (struct basler_device_information*) ctrl->p_new.p;

		if (ctrl->elem_size == sizeof(struct basler_device_information))
		{
			memcpy(l_bdi, &sensor->device_information, sizeof(struct basler_device_information));
			ret = 0;
		}
		else
		{
			ret = -ENOMEM;
		}
		break;

	case V4L2_CID_BASLER_CSI_INFORMATION:
		if (ctrl->elem_size == sizeof(struct basler_csi_information))
		{
			struct basler_csi_information* l_bci = NULL;
			l_bci = (struct basler_csi_information*) ctrl->p_new.p;
			ret = basler_retrieve_csi_information(sensor, l_bci);
		}
		else
		{
			ret = -ENOMEM;
		}
		break;

	default:
		ret = -EINVAL;
		break;
	}

	return ret;
}


/**
 * basler_camera_link_setup 
 *
 * Note: Function is needed by imx8qm
 *
 * Returns always zero
 */
static int basler_camera_link_setup(struct media_entity *entity,
			   const struct media_pad *local,
			   const struct media_pad *remote, u32 flags)
{
	return 0;
}

static const struct media_entity_operations basler_camera_sd_media_ops = {
	.link_setup = basler_camera_link_setup,
};


static int basler_camera_init_controls(struct basler_camera_dev *sensor)
{
	struct basler_camera_ctrls *ctrls = &sensor->ctrls;
	struct v4l2_ctrl_handler *hdl = &ctrls->handler;
	int ret;

	v4l2_ctrl_handler_init(hdl, 32);

	/* we can use our own mutex for the ctrl lock */
	hdl->lock = &sensor->lock;

	ctrls->access_register = v4l2_ctrl_new_custom(hdl, &ctrl_access_register, NULL);
	if (hdl->error)
	{
		dev_err(&sensor->i2c_client->dev, "Register ctrl access_register failed: %d\n", hdl->error);
		ret = hdl->error;
		goto free_ctrls;
	}

	ctrls->basler_device_information = v4l2_ctrl_new_custom(hdl, &ctrl_basler_device_information, NULL);
	if (hdl->error)
	{
		dev_err(&sensor->i2c_client->dev, "Register ctrl device_information failed: %d\n", hdl->error);
		ret = hdl->error;
		goto free_ctrls;
	}

	ctrls->basler_interface_version = v4l2_ctrl_new_custom(hdl, &ctrl_basler_interface_version, NULL);
	if (hdl->error)
	{
		dev_err(&sensor->i2c_client->dev, "Register ctrl interface_version failed: %d\n", hdl->error);
		ret = hdl->error;
		goto free_ctrls;
	}

	ctrls->basler_csi_information = v4l2_ctrl_new_custom(hdl, &ctrl_basler_csi_information, NULL);
	if (hdl->error)
	{
		dev_err(&sensor->i2c_client->dev, "Register ctrl csi_information failed: %d\n", hdl->error);
		ret = hdl->error;
		goto free_ctrls;
	}

	sensor->sd.ctrl_handler = hdl;
	if (sensor->sd.ctrl_handler->error) {
		dev_dbg(sensor->sd.v4l2_dev->dev, "%s: ctrl handler error.\n", __func__);
		ret = sensor->sd.ctrl_handler->error;
		goto free_ctrls;
	}

	return 0;

free_ctrls:
	v4l2_ctrl_handler_free(hdl);
	return ret;
}

static void basler_camera_power_on(struct basler_camera_dev *sensor, bool enable)
{
	if (!sensor->pwdn_gpio)
		return;

	gpiod_set_value_cansleep(sensor->pwdn_gpio, enable ? 0 : 1);
}

static void basler_camera_reset(struct basler_camera_dev *sensor)
{
	if (!sensor->reset_gpio)
		return;

	/* camera reset */
	gpiod_set_value_cansleep(sensor->reset_gpio, 0);
	usleep_range(1000, 2000);

	gpiod_set_value_cansleep(sensor->reset_gpio, 1);
	usleep_range(5000, 10000);
}


static int basler_camera_probe(struct i2c_client *client,
			const struct i2c_device_id *id)
{
	struct device *dev = &client->dev;
	struct basler_camera_dev *sensor;
	int ret;
	
	dev_dbg(dev, " %s driver start probing\n", SENSOR_NAME);

	sensor = devm_kzalloc(dev, sizeof(*sensor), GFP_KERNEL);
	if (!sensor)
		return -ENOMEM;

	sensor->i2c_client = client;

	/* get system clock (xclk) */
	sensor->xclk = devm_clk_get(dev, "xclk");
	if (IS_ERR(sensor->xclk)) {
		dev_err(dev, "failed to get xclk\n");
		return PTR_ERR(sensor->xclk);
	}

	sensor->xclk_freq = clk_get_rate(sensor->xclk);
	if (sensor->xclk_freq < XCLK_MIN ||
	    sensor->xclk_freq > XCLK_MAX) {
		dev_err(dev, "xclk frequency out of range: %d Hz\n",
			sensor->xclk_freq);
		return -EINVAL;
	}

	/* request optional power down pin */
	sensor->pwdn_gpio = devm_gpiod_get_optional(dev, "powerdown",
						    GPIOD_OUT_HIGH);
	if (IS_ERR(sensor->pwdn_gpio)) {
		dev_info(dev, "can't get %s GPIO\n", "powerdown");
	}
	/* request optional reset pin */
	sensor->reset_gpio = devm_gpiod_get_optional(dev, "reset",
						     GPIOD_OUT_LOW);
	if (IS_ERR(sensor->reset_gpio)) {
		dev_info(dev, "can't get %s GPIO\n", "reset");
	}

	basler_camera_power_on(sensor, true);
	basler_camera_reset(sensor);

	v4l2_i2c_subdev_init(&sensor->sd, client, &basler_camera_subdev_ops);

	sensor->sd.flags |= V4L2_SUBDEV_FL_HAS_DEVNODE;
	sensor->pad.flags = MEDIA_PAD_FL_SOURCE;
	sensor->sd.entity.function = MEDIA_ENT_F_CAM_SENSOR;
	sensor->sd.entity.ops = &basler_camera_sd_media_ops;
	ret = media_entity_pads_init(&sensor->sd.entity, 1, &sensor->pad);
	if (ret)
		return ret;

	mutex_init(&sensor->lock);

	ret = basler_camera_init_controls(sensor);
	if (ret)
		goto entity_cleanup;

	ret = v4l2_async_register_subdev(&sensor->sd);
	if (ret)
		goto entity_cleanup;

	ret = basler_retrieve_device_information(client, &sensor->device_information);
	if (ret)
		goto entity_cleanup;

	dev_dbg(dev, " %s driver probed\n", SENSOR_NAME);

	return 0;

entity_cleanup:
	mutex_destroy(&sensor->lock);
	media_entity_cleanup(&sensor->sd.entity);
	return ret;
}

static int basler_camera_remove(struct i2c_client *client)
{
	struct v4l2_subdev *sd = i2c_get_clientdata(client);
	struct basler_camera_dev *sensor = to_basler_camera_dev(sd);

	v4l2_async_unregister_subdev(&sensor->sd);
	mutex_destroy(&sensor->lock);
	media_entity_cleanup(&sensor->sd.entity);
	v4l2_ctrl_handler_free(&sensor->ctrls.handler);

	return 0;
}

static const struct i2c_device_id basler_camera_id[] = {
	{"basler-camera", 0},
	{},
};
MODULE_DEVICE_TABLE(i2c, basler_camera_id);

static const struct of_device_id basler_camera_dt_ids[] = {
	{ .compatible = "basler,basler-camera" },
	{ /* sentinel */ }
};
MODULE_DEVICE_TABLE(of, basler_camera_dt_ids);

static struct i2c_driver basler_camera_i2c_driver = {
	.driver = {
		.name  = "basler-camera",
		.of_match_table	= basler_camera_dt_ids,
	},
	.id_table = basler_camera_id,
	.probe    = basler_camera_probe,
	.remove   = basler_camera_remove,
};

module_i2c_driver(basler_camera_i2c_driver);

MODULE_DESCRIPTION("Basler camera subdev driver");
MODULE_AUTHOR("Sebastian Suesens <sebastian.suesens@baslerweb.com>");
MODULE_LICENSE("GPL");


