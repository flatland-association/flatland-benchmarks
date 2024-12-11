FROM codalab/codalab-legacy:py37


# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

COPY environment.yml ./
COPY run.sh ./
COPY random_agent.py ./

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

