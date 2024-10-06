#
# Firmware license file name is too generic.
# Since license file is a separate source, file LICENSE will be saved as downloads/LICENSE.
# This file can be overriden with other recipe that populates file named LICENSE as a source.
# Most probably same file was populated by onnxruntime recipe.
#

SRC_URI:append = ";downloadfilename=LICENSE.hailo"

python () {
    lic = d.getVar("LIC_FILES_CHKSUM")
    lic = lic.replace("LICENSE", "LICENSE.hailo")
    d.setVar("LIC_FILES_CHKSUM", lic)
}
