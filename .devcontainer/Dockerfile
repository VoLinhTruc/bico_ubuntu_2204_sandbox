FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=host.docker.internal:0
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en

ENV USERNAME=developer
ENV USER_GID=1000
ENV DOCKER_GID=999

# Proxy using "Px by BD"
# MY_PROXY_IP is the host IP
ENV MY_PROXY_IP=host.docker.internal
ENV MY_PROXY_PORT=3128
# ENV http_proxy=http://$MY_PROXY_IP:$MY_PROXY_PORT
# ENV https_proxy=http://$MY_PROXY_IP:$MY_PROXY_PORT

SHELL ["/bin/bash", "-c"]

# --- System utilities and shell tools ---
RUN apt-get update && apt-get install -y \
    passwd \
    sudo \
    tzdata \
    locales \
    wget \
    curl \
    vim \
    nano \
    fish \
    tmux

# --- Networking tools ---
RUN apt-get install -y \
    iputils-ping \
    net-tools \
    netcat
    
# --- Development tools and compilers ---
RUN apt-get install -y \
    build-essential \
    g++-17 \
    gdb \
    git \
    git-lfs \
    cmake \
    ninja-build \
    autoconf \
    libtool \
    pkg-config \
    libssl-dev \
    # --- C++/Boost libraries ---
    libboost-dev \
    libboost-system-dev

# --- Python development ---
RUN apt-get install -y \
    python-is-python3 \
    python3-pip \
    python3-dev

# Clean up apt cache to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*


# Generate locale
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Set timezone to Vietnam/Hanoi
RUN ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && \
    echo "Asia/Ho_Chi_Minh" > /etc/timezone


RUN echo "root:1" | chpasswd
# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME && \
    useradd --uid $USER_GID --gid $USERNAME --shell /bin/bash --create-home $USERNAME
RUN groupadd -for -g $DOCKER_GID docker \
 && usermod -aG docker $USERNAME
RUN echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# # Switch to the USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME


CMD ["bash"]
