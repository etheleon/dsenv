FROM etheleon/dsenv:base
LABEL maintainer="etheleon@protonmail.com"

#user uesu
RUN useradd -m -s /bin/zsh uesu && \
    echo 'uesu ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER uesu
WORKDIR /home/uesu

# install zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#vim mapping
RUN echo "set keymap vi-command\n" >> $HOME/.inputrc && \
    echo "Control-l: clear-screen\n" >> $HOME/.inputrc && \
    echo "set keymap vi-insert\n" >> $HOME/.inputrc && \
    echo "Control-l: clear-screen\n" >> $HOME/.inputrc && \
    echo "bindkey -v\n" >> $HOME/.zshrc
    echo "bindkey '^R' history-incremental-search-backward" >> $HOME/.zshrc

#linuxbrew
RUN git clone https://github.com/Linuxbrew/brew.git /home/uesu/.linuxbrew
ENV PATH=/home/uesu/.linuxbrew/bin:/home/uesu/.linuxbrew/sbin:$PATH
RUN brew update
ENV MANPATH="$(brew --prefix)/share/man:$MANPATH" \
    INFOPATH="$(brew --prefix)/share/info:$INFOPATH"


# install python
RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /home/uesu/anaconda3 && \
    rm ~/anaconda.sh
ENV PATH=/home/uesu/anaconda3/bin
