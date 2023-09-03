FROM debian:bullseye

ENV DEBIAN_FRONTEND=non-interactive

RUN apt-get update
RUN apt-get install -y gawk wget git diffstat unzip texinfo gcc build-essential \
    chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils \
    iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev \
    python3-subunit mesa-common-dev zstd liblz4-tool file locales


RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8

# You can set the container's root password here. Use this only locally since this
# is clearly a security issue.
RUN echo "root:root" | chpasswd

ARG USERNAME=build
ARG PUID=1000
ARG PGID=1000

RUN groupadd -g ${PGID} ${USERNAME} && useradd -u ${PUID} -g ${USERNAME} -d /home/${USERNAME} ${USERNAME} && mkdir /home/${USERNAME} && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

COPY .bashrc /home/${USERNAME}/.bashrc

USER ${USERNAME}

WORKDIR /home/${USERNAME}

