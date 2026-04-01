FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gdb-multiarch \
    cmake \
    build-essential \
    ninja-build \
    clangd \
    openocd \
    usbutils \
    ncdu \
    tree \
    ca-certificates \
    sudo \
    python3 \
    python3-venv \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
    
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME