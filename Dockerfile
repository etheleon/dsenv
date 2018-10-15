FROM etheleon/dsenv:base
LABEL maintainer="etheleon@protonmail.com"

#user uesu
RUN useradd -m -s /bin/zsh uesu \
    && echo 'uesu ALL=(ALL) NOPASSWD:ALL' >>/etc/sudoers
USER uesu
WORKDIR /home/uesu

# install zsh
ENV TERM xterm-256color
RUN sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#vim mapping
RUN echo "set keymap vi-command\n" >> $HOME/.inputrc \
    && echo "set editing-mode vi" >> $HOME/.inputrc \
    && echo "Control-l: clear-screen\n" >> $HOME/.inputrc \
    && echo "set keymap vi-insert\n" >> $HOME/.inputrc \
    && echo "Control-l: clear-screen\n" >> $HOME/.inputrc \
    && echo "bindkey -v\n" >> $HOME/.zshrc \
    && echo "bindkey '^R' history-incremental-search-backward" >> $HOME/.zshrc


#linuxbrew
RUN git clone https://github.com/Linuxbrew/brew.git /home/uesu/.linuxbrew
ENV PATH=/home/uesu/.linuxbrew/bin:/home/uesu/.linuxbrew/sbin:$PATH
RUN brew update
ENV MANPATH="$(brew --prefix)/share/man:$MANPATH" \
    INFOPATH="$(brew --prefix)/share/info:$INFOPATH"

#neovi
RUN git clone https://github.com/etheleon/nvim.git $HOME/.config/nvim
RUN echo | echo | nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1
RUN echo | echo | nvim -i NONE -c UpdateRemotePlugins -c quitall > /dev/null 2>&1


# install python
RUN wget --quiet https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /home/uesu/anaconda3 && \
    rm ~/anaconda.sh
ENV PATH=/home/uesu/anaconda3/bin:$PATH

# configure jupyter and prompt for password
RUN pip install --upgrade jupyter && \
    jupyter notebook --generate-config && \
    echo "c.NotebookApp.ip = '*'" >> $HOME/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.open_browser = False" >> $HOME/.jupyter/jupyter_notebook_config.py

#configure ipython
RUN ipython profile create && \
    echo "c.InteractiveShellApp.extensions = ['autoreload']\n" >> $HOME/.ipython/profile_default/ipython_config.py && \
    echo "c.InteractiveShellApp.exec_lines = ['%autoreload 2']\n" >> $HOME/.ipython/profile_default/ipython_config.py && \
    echo "c.InteractiveShellApp.exec_lines.append('print(\"Warning: disable autoreload in ipython_config.py to improve performance.\")')\n" >> $HOME/.ipython/profile_default/ipython_config.py && \
    echo "c.TerminalInteractiveShell.editing_mode = 'vi'\n" >> $HOME/.ipython/profile_default/ipython_config.py

#tmux
WORKDIR /home/uesu
RUN git clone https://github.com/gpakosz/.tmux.git && \
 ln -s -f .tmux/.tmux.conf && \
 cp .tmux/.tmux.conf.local .


