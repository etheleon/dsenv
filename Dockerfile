FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
LABEL maintainer="etheleon@protonmail.com"

RUN apt-get -f -y upgrade && \
    apt-get clean && \
    apt-get update --fix-missing && \
    apt-get -f -y install \
    tmux \
    build-essential \
    gcc \
    g++ \
    make \
    cmake \
    binutils \
    curl \
    git \
    zsh \
    software-properties-common \
    file \
    locales \
    uuid-runtime \
    wget \
    bzip2 \
    ca-certificates \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    mercurial \
    subversion \
    python-pip \
    python3-pip \
    ruby  \
    sudo \
    htop \
    tree && \
    apt-get clean

#neovim
RUN add-apt-repository ppa:neovim-ppa/stable && \
    apt-get update && \
    apt-get install -y -f neovim fonts-powerline && \
    /usr/bin/pip3 install neovim

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    SHELL=/bin/zsh

#Timezone
ENV TZ 'Asia/Singapore'
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
	rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    && locale-gen en_US.UTF-8 \
	&& apt-get install locales \
	&& localedef -i en_US -f UTF-8 en_US.UTF-8
