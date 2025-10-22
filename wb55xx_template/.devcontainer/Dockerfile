# Fetch Arch Linux image (which includes a recent, stable version)
FROM archlinux:latest

# Update repositories and install necessary packages using pacman
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    python \
    base-devel \
    make \
    arm-none-eabi-gcc \
    arm-none-eabi-binutils \
    arm-none-eabi-newlib \
    arm-none-eabi-gdb \
    openocd \
    usbutils \
    usbip && \
    # Clean cache to keep the image small
    pacman -Scc --noconfirm

# Create the user (this part remains the same)
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Switch to the non-root user
USER vscode

# The rest of your file remains the same...
# WORKDIR /home/vscode/project

# ENTRYPOINT ["..."]
