FROM continuumio/miniconda3

RUN apt-get update && apt-get install gcc build-essential wget zip -y

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Use non-root user
RUN useradd conda --home-dir /home/conda --create-home
RUN chown -R conda /opt/conda
USER conda

# setup flatland-rl conda env
COPY environment.yml ./
RUN conda --version  && \
    conda env create -f environment.yml && \
    conda init bash && \
    source /home/conda/.bashrc && \
    source activate base && \
    conda env list  && \
    conda activate flatland-rl && \
    # TODO temporary workaround till 4.0.4 is released (https://github.com/flatland-association/flatland-rl/pull/112)
    git clone https://github.com/flatland-association/flatland-rl.git /tmp/flatland-rl && cd /tmp/flatland-rl && python -m pip install  -r requirements-dev.txt && python -m build && python -m pip install /tmp/flatland-rl/dist/flatland_rl-4.0.3.*.tar.gz && python -m pip list && \
    python -c 'from flatland.evaluators.client import FlatlandRemoteClient'

COPY run.sh ./
COPY random_agent.py ./

ENTRYPOINT bash run.sh
