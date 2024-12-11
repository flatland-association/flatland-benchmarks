FROM codalab/codalab-legacy:py37


# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# download environment.yml for flatland-rl conda env
# TODO hard-code in repo?
RUN wget "https://gitlab.aicrowd.com/flatland/flatland-starter-kit/-/archive/master/flatland-starter-kit-master.zip" && \
    unzip flatland-starter-kit-master.zip && \
    rm flatland-starter-kit-master.zip
WORKDIR flatland-starter-kit-master

# setup flatland-rl conda env
RUN conda --version  && \
    conda env create -f environment.yml && \
    conda init bash && \
    source ~/.bashrc && \
    conda env list  && \
    conda activate flatland-rl

# install flatland-rl pip package
RUN python --version  && \
    python -m pip install --upgrade pip && \
    python -m pip install pyarrow flatland-rl
