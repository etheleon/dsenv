# This script is designed to work with ubuntu 16.04 LTS
FROM ubuntu:16.04

# ensure system is updated and has basic build tools
RUN apt-get -f -y upgrade
RUN apt-get clean
RUN apt-get update --fix-missing
RUN apt-get -f -y install \
    tmux \
    build-essential \
    gcc g++ make \
    binutils \
    curl \
    git \
    zsh \
    software-properties-common file locales uuid-runtime \
    wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    mercurial subversion \
    python-pip \
    python3-pip \
    ruby  \
    sudo \
    htop tree cmake
RUN apt-get clean
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt-get update
RUN apt-get install -y -f neovim fonts-powerline
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    SHELL=/bin/zsh

RUN /usr/bin/pip3 install neovim
RUN apt-get update --fix-missing

#Timezone
ENV TZ 'America/New_York'
RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get install -y tzdata && \
	rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    locale-gen en_US.UTF-8

#user uesu
RUN useradd -m -s /bin/zsh uesu
RUN echo 'uesu ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER uesu
WORKDIR /home/uesu

# install Anaconda for current user
# RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
#     wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
#     /bin/bash ~/anaconda.sh -b -p /opt/conda && \
#     rm ~/anaconda.sh

# install zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /home/uesu/anaconda3 && \
    rm ~/anaconda.sh

#linuxbrew
RUN git clone https://github.com/Linuxbrew/brew.git /home/uesu/.linuxbrew
ENV PATH=/home/uesu/anaconda3/bin:/home/uesu/.linuxbrew/bin:/home/uesu/.linuxbrew/sbin:$PATH
#RUN brew doctor
RUN brew update
ENV MANPATH="$(brew --prefix)/share/man:$MANPATH" \
    INFOPATH="$(brew --prefix)/share/info:$INFOPATH"

# install and configure keras
RUN /home/uesu/anaconda3/bin/pip install keras==2.1.3
RUN mkdir ~/.keras
RUN echo '{ "image_dim_ordering": "th", "epsilon": 1e-07, "floatx": "float32", "backend": "tensorflow" }' > ~/.keras/keras.json

# configure jupyter and prompt for password
RUN pip install --upgrade jupyter
RUN jupyter notebook --generate-config
#RUN jupass=`python -c "from notebook.auth import passwd; print(passwd())"`
#RUN echo "c.NotebookApp.password = u'"$jupass"'" >> $HOME/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.ip = '*'" >> $HOME/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py

#configure ipython
RUN ipython profile create

#neovi
RUN echo "set editing-mode vi" >> $HOME/.inputrc
RUN git clone https://github.com/etheleon/nvim.git $HOME/.config/nvim
RUN echo | echo | nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1
RUN echo | echo | nvim -i NONE -c UpdateRemotePlugins -c quitall > /dev/null 2>&1

#vim mapping
RUN echo "set keymap vi-command\n" >> $HOME/.inputrc
RUN echo "Control-l: clear-screen\n" >> $HOME/.inputrc
RUN echo "set keymap vi-insert\n" >> $HOME/.inputrc
RUN echo "Control-l: clear-screen\n" >> $HOME/.inputrc
RUN echo "bindkey -v\n" >> $HOME/.zshrc
RUN echo "bindkey '^R' history-incremental-search-backward" >> $HOME/.zshrc

RUN echo "c.InteractiveShellApp.extensions = ['autoreload']\n" >> $HOME/.ipython/profile_default/ipython_config.py
RUN echo "c.InteractiveShellApp.exec_lines = ['%autoreload 2']\n" >> $HOME/.ipython/profile_default/ipython_config.py
RUN echo "c.InteractiveShellApp.exec_lines.append('print(\"Warning: disable autoreload in ipython_config.py to improve performance.\")')\n" >> $HOME/.ipython/profile_default/ipython_config.py
RUN echo "c.TerminalInteractiveShell.editing_mode = 'vi'\n" >> $HOME/.ipython/profile_default/ipython_config.py

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
RUN $HOME/anaconda3/bin/pip install --upgrade https://github.com/mind/wheels/releases/download/tf1.4.1-cpu-mkl/tensorflow-1.4.1-cp36-cp36m-linux_x86_64.whl
RUN $HOME/anaconda3/bin/pip install jupyter-tensorboard

WORKDIR /home/uesu/.local/share/jupyter/nbextensions
RUN git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding
RUN jupyter nbextension enable vim_binding/vim_binding

#tmux
WORKDIR /home/uesu
RUN git clone https://github.com/gpakosz/.tmux.git
RUN ln -s -f .tmux/.tmux.conf
RUN cp .tmux/.tmux.conf.local .

#MKL
RUN git clone https://github.com/01org/mkl-dnn.git
WORKDIR mkl-dnn
RUN cd scripts && ./prepare_mkl.sh && cd ..
RUN mkdir -p build && cd build && cmake .. && make
WORKDIR build
RUN sudo make install

WORKDIR /home/uesu
RUN rm -r mkl-dnn

RUN git clone --recursive https://github.com/dmlc/xgboost
RUN mkdir xgboost/build
WORKDIR /home/uesu/xgboost/build
RUN cmake ..
RUN make -j
WORKDIR /home/uesu/xgboost/python-package
RUN /home/uesu/anaconda3/bin/python setup.py develop --user

RUN conda install -y rpy2 tqdm r-tidyverse r-devtools
RUN pip install sklearn_pandas

RUN conda install numpy
