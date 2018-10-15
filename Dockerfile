FROM etheleon/dsenv:uesu
LABEL maintainer="etheleon@protonmail.com"

# ds packages
RUN conda install -y rpy2 tqdm r-tidyverse r-devtools numpy
RUN pip install sklearn_pandas
