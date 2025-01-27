#!/bin/bash
echo "/ start evaluator/run.sh"
set -e
source /home/conda/.bashrc
source activate base
conda activate flatland-rl
python -m pip list
python evaluator.py
echo "\\ end evaluator/run.sh"
