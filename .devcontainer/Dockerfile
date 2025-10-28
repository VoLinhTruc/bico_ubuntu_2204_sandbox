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
ENV http_proxy=http://$MY_PROXY_IP:$MY_PROXY_PORT
ENV https_proxy=http://$MY_PROXY_IP:$MY_PROXY_PORT

SHELL ["/bin/bash", "-c"]

# Install dependencies
RUN apt-get update
RUN apt-get install -y \
    # --- System utilities and shell tools ---
    passwd \
    sudo \
    tzdata \
    locales \
    wget \
    curl \
    vim \
    nano \
    fish \
    tmux \
    # --- Networking tools ---
    iputils-ping \
    net-tools \
    netcat \
    # --- Editors and terminal utilities ---
    gnome-terminal \
    dbus-x11 \
    # --- GNOME/GTK/Theme packages ---
    gnome-themes-extra \
    gtk2-engines-murrine \
    gtk2-engines-pixbuf \
    dconf-cli \
    libglib2.0-bin \
    gsettings-desktop-schemas \
    # gnome-shell-extensions \
    # --- Development tools and compilers ---
    build-essential \
    g++-17 \
    gdb \
    git \
    cmake \
    ninja-build \
    autoconf \
    libtool \
    pkg-config \
    libssl-dev \
    # --- C++/Boost libraries ---
    libboost-dev \
    libboost-system-dev \
    # --- Python development ---
    python-is-python3 \
    python3-pip \
    python3-dev \
    # --- JSON and data tools ---
    jq \
    nlohmann-json3-dev
    
    # --- Qt and Qt Creator ---
# RUN apt-get install -y \
#     qtbase5-dev \
#     qt6-base-dev \
#     qt6-declarative-dev \
#     qt6-tools-dev \
#     qt6-qmltooling-plugins \
#     qtcreator

# # Clean up apt cache to reduce image size
# # RUN apt-get clean && \
#     # rm -rf /var/lib/apt/lists/*


# Generate locale
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# Set timezone to Vietnam/Hanoi
RUN ln -sf /usr/share/zoneinfo/Asia/Ho_Chi_Minh /etc/localtime && \
    echo "Asia/Ho_Chi_Minh" > /etc/timezone

# RUN git config --global --unset http.proxy || true "" \
#  && git config --global --unset https.proxy || true ""

# # Set up GNOME dark theme
# RUN gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'


# Install Docker CLI ---------------------------------------------
RUN apt install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
RUN echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update
RUN apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

RUN apt install -y \
    fuse-overlayfs
# ---------------------------------------------------------------


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

# # Configure bashrc for the user
# RUN echo 'fish' >> /home/$USERNAME/.bashrc

 
# # Create a directory for the project
# WORKDIR /workspaces
 
# Avoid error: zlib version less than 1.2.3
RUN cd ~ && \
    git clone https://github.com/madler/zlib.git -b v1.3.1 && \
    cd ~/zlib && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    sudo make install
 
# # RUN git clone --branch v1.17.0 --depth 1 https://github.com/google/googletest.git /workspaces/googletest
# # RUN git clone https://github.com/meekrosoft/fff.git /workspaces/fff \
# #     && cd fff && git checkout 5111c61e1ef7848e3afd3550044a8cf4405f4199 && cd ..

# # CMake 3.22.2 installation
# RUN wget -P /workspaces/cmake_3.22.2 https://github.com/Kitware/CMake/releases/download/v3.22.2/cmake-3.22.2-linux-x86_64.tar.gz && \
#     mkdir -p /opt/cmake && \
#     tar -zxvf /workspaces/cmake_3.22.2/cmake-3.22.2-linux-x86_64.tar.gz -C /opt/cmake && \
#     ln -s /opt/cmake/cmake-3.22.2-linux-x86_64/bin/cmake /usr/local/bin/cmake

# # Unset proxy for git, prevent passing WSL git proxy config (http://wsl-proxy:3128) 
# # to the container (container does not know what wsl-proxy is)
# RUN git config --global http.proxy = ""\
#  && git config --global https.proxy = ""
# RUN git config --global --unset http.proxy || true ""\
#  && git config --global --unset https.proxy || true ""

# Copy and set up entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN sudo chmod +x /entrypoint.sh

# Set the entry point for the container
ENTRYPOINT ["/entrypoint.sh"]
CMD ["fish"]
