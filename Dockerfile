FROM etheleon/dsenv:uesu
LABEL maintainer="etheleon@protonmail.com"

# ds packages
RUN conda install -y rpy2 tqdm r-tidyverse r-devtools numpy
RUN pip install sklearn_pandas

#xgboost
RUN git clone --recursive https://github.com/dmlc/xgboost
RUN mkdir xgboost/build
WORKDIR /home/uesu/xgboost/build
RUN cmake ..
RUN make -j
WORKDIR /home/uesu/xgboost/python-package
RUN /home/uesu/anaconda3/bin/python setup.py develop --user


