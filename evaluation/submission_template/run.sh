#!/bin/bash
echo "/ start submission_template/run.sh"
set -e
source /home/conda/.bashrc
source activate base
conda activate flatland-rl
python -m pip list
python random_agent.py
echo "\\ end submission_template/run.sh"
