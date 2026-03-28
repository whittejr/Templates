FROM debian:bookworm-slim as build

RUN apt-get update && apt-get install -y wget xz-utils

WORKDIR /tmp

RUN wget --progress=dot:giga https://developer.arm.com/-/media/Files/downloads/gnu/13.2.rel1/binrel/arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz

RUN mkdir -p /opt/arm-gcc \
    && tar -xf arm-gnu-toolchain-13.2.rel1-x86_64-arm-none-eabi.tar.xz -C /opt/arm-gcc --strip-components=1

WORKDIR /opt/arm-gcc
RUN rm -rf share/doc share/man share/info \
    && rm -rf lib/gcc/arm-none-eabi/*/plugin

FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    gdb-multiarch \
    cmake \
    build-essential \
    ninja-build \
    clangd \
    # Debuggers e Ferramentas USB
    openocd \
    usbutils \
    ncdu \
    tree \
    # Utilitários básicos
    ca-certificates \
    sudo \
    python3 \
    python3-pip \
    python3-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
    
    COPY --from=build /opt/arm-gcc /opt/arm-gcc

# Venv configuration
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# COPY tools/dsp_analysis/requirements.txt /tmp/
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# --- Configuração do Usuário ---
# Cria o usuário 'vscode' para evitar problemas de permissão com arquivos do Windows
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

USER $USERNAME