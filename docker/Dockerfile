FROM ubuntu:22.04

ARG USERNAME
ARG UID

# Install basic utilities
RUN sed -i 's|deb http://us.archive.ubuntu.com/ubuntu/|deb mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list && \
    apt-get -q update && \
    apt-get -q -y install file build-essential libncurses5-dev \
      git bzr cvs subversion unzip bc swig \
      sudo wget cpio rsync dosfstools python3-setuptools \
      python3-distutils python3-dev libssl-dev \
      vim less && \
    apt-get -q -y autoremove && \
    apt-get -q -y clean

# Create a non-root user(sudoers w/o password) and switch to it 
RUN useradd --uid ${UID} --create-home --shell /bin/bash -G sudo,root ${USERNAME} \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# ENV Settings 
ENV HOME /home/${USERNAME}

# copy build script
COPY br-build.sh .