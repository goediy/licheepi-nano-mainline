FROM ubuntu:24.04

ARG USERNAME
ARG UID

# Create a non-root user(sudoers w/o password) and switch to it
RUN EXISTING_USER=$(getent passwd | awk -F: -v uid="$UID" '$3 == uid {print $1}') && \
    if [ -z "$EXISTING_USER" ]; then \
       useradd --uid ${UID} --create-home --shell /bin/bash -G sudo,root ${USERNAME} && \
       echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers; \
    fi

RUN mkdir /workdir
WORKDIR /workdir

# Install basic utilities
RUN sed -i 's|deb http://us.archive.ubuntu.com/ubuntu/|deb mirror://mirrors.ubuntu.com/mirrors.txt|g' /etc/apt/sources.list && \
    apt-get -q update && \
    apt-get -q -y install file build-essential libncurses5-dev \
      git bzr cvs subversion unzip bc swig iputils-ping \
      sudo wget cpio rsync dosfstools python3-setuptools \
      python3-dev libssl-dev \
      vim less && \
    apt-get -q -y autoremove && \
    apt-get -q -y clean

# ENV Settings 
ENV HOME /workdir

# copy build script
COPY br-build.sh .