FROM cptnalf/jetson-ffmpeg-frigate:4.3.2 as src

FROM blakeblackshear/frigate:0.10.0-aarch64 AS base

LABEL maintainer "blakeb@blakeshome.com"
LABEL maintainer "captainalf@gmail.com"

# jetson nano, and tx1.
# 194 = xavier
# 186 = tx2
ARG SOC=t210

ENV DEBIAN_FRONTEND=noninteractive

ADD --chown=root:root https://repo.download.nvidia.com/jetson/jetson-ota-public.asc /etc/apt/trusted.gpg.d/jetson-ota-public.asc
RUN chmod 644 /etc/apt/trusted.gpg.d/jetson-ota-public.asc \
    && apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
    && echo "deb https://repo.download.nvidia.com/jetson/common r32.5 main" > /etc/apt/sources.list.d/nvidia-l4t-apt-source.list \
    && echo "deb https://repo.download.nvidia.com/jetson/${SOC} r32.5 main" >> /etc/apt/sources.list.d/nvidia-l4t-apt-source.list \
    && apt-get update \
    && rm -rf /var/lib/apt/lists/*

# this is a dependency of nvidia-l4t-core.
ADD http://http.us.debian.org/debian/pool/main/libf/libffi/libffi6_3.2.1-9_arm64.deb /opt/
RUN dpkg -i /opt/libffi6_3.2.1-9_arm64.deb

# first 2 cmds make nvidia-l4t ignore device-requirements.
RUN mkdir -p /opt/nvidia/l4t-packages/ && \
    touch /opt/nvidia/l4t-packages/.nv-l4t-disable-boot-fw-update-in-preinstall && \
    apt-get -qq update && \
    apt-get install --no-install-recommends -y \
# not sure how much of this is really needed...
      nvidia-l4t-core \
      nvidia-l4t-multimedia \
      nvidia-l4t-multimedia-utils \
      nvidia-l4t-cuda \
      nvidia-l4t-3d-core \
      nvidia-l4t-wayland \
      nvidia-l4t-x11 \
      nvidia-l4t-firmware \
      nvidia-l4t-tools

# copy over the jetson-enabled FFMPEG
COPY --from=src /usr/local/ /usr/local/

# fix the library loading.
RUN echo "/usr/lib/aarch64-linux-gnu/tegra" >> /etc/ld.so.conf.d/nvidia-tegra.conf && \
    ldconfig 

# add the local-user
RUN \
  useradd --uid 911 --user-group --create-home abc

# copy over the edited startup files.
COPY rootfs/ /

ENV NVIDIA_DRIVER_CAPABILITIES all
ENV NVIDIA_VISIBLE_DEVICES all

ENTRYPOINT [ "/init" ]

# tag cptnalf/frigate-jetson:0.10.0
