FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# ------------------------------------------------------------
# Install only crossbuild-essential-arm64 + kernel deps
# ------------------------------------------------------------
RUN apt-get update && apt-get install -y \
    git build-essential bc bison flex libssl-dev \
    libncurses-dev libelf-dev dwarves \
    crossbuild-essential-arm64 \
    make xz-utils rsync wget curl \
    && apt-get clean

# ------------------------------------------------------------
# Clone Raspberry Pi Kernel
# ------------------------------------------------------------
RUN git clone --depth=1 --branch rpi-6.12.y https://github.com/raspberrypi/linux.git /rpi-kernel

WORKDIR /rpi-kernel

# ------------------------------------------------------------
# Copy your Pi config if present
# ------------------------------------------------------------
#COPY config_pi .config

# ------------------------------------------------------------
# Apply kernel configuration
# ------------------------------------------------------------
RUN if [ -f .config ]; then \
        echo "[INFO] Using config_pi"; \
        make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- olddefconfig; \
    else \
        echo "[INFO] Using default bcm2711_defconfig"; \
        make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcm2711_defconfig; \
    fi

# ------------------------------------------------------------
# Kernel preparation for external modules
# ------------------------------------------------------------
RUN make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- prepare
RUN make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_prepare

# ------------------------------------------------------------
# Build kernel + modules + dtbs
# ------------------------------------------------------------
RUN make -j$(nproc) ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- Image modules dtbs

# ------------------------------------------------------------
# Environment for building external modules
# ------------------------------------------------------------
ENV KERNEL_SRC=/rpi-kernel
ENV ARCH=arm64
ENV CROSS_COMPILE=aarch64-linux-gnu-

WORKDIR /workspace
CMD ["/bin/bash"]
