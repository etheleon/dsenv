FROM etheleon/dsenv:datascience

# install and configure keras
RUN /home/uesu/anaconda3/bin/pip install keras==2.1.3 \
	&& mkdir ~/.keras \
	&& echo '{ "image_dim_ordering": "th", "epsilon": 1e-07, "floatx": "float32", "backend": "tensorflow" }' > ~/.keras/keras.json

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
RUN $HOME/anaconda3/bin/pip install --upgrade https://github.com/mind/wheels/releases/download/tf1.4.1-gpu-cuda9/tensorflow-1.4.1-cp36-cp36m-linux_x86_64.whl \
	&& $HOME/anaconda3/bin/pip install jupyter-tensorboard

RUN sudo apt-get install -y --allow-change-held-packages --allow-downgrades libcudnn7=7.0.5.15-1+cuda9.0

#MKL
RUN git clone https://github.com/01org/mkl-dnn.git
WORKDIR mkl-dnn
RUN cd scripts && ./prepare_mkl.sh && cd ..
RUN mkdir -p build && cd build && cmake .. && make
WORKDIR build
RUN sudo make install
WORKDIR /home/uesu
RUN rm -r mkl-dnn

