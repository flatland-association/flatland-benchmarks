#!/bin/bash
set -euxo pipefail
source /home/conda/.bashrc
source activate base
conda activate flatland-rl
#python -m pip list

# fix till 4.1.3: https://github.com/flatland-association/flatland-rl/pull/228/files
sed -i "s/type=click.Path(exists=True),/type=click.Path(exists=True, path_type=Path),/g" /opt/conda/envs/flatland-rl/lib/python3.12/site-packages/flatland/trajectories/trajectories.py

export PYTHONPATH=$PWD

flatland-trajectory-generate-from-policy $@

