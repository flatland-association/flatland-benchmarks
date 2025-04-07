#!/bin/bash
echo "/ start evaluator/run.sh"

# workaround for https://github.com/boto/boto3/issues/4392#issue-2791555898
export AWS_REQUEST_CHECKSUM_CALCULATION="when_required"
export AWS_RESPONSE_CHECKSUM_VALIDATION="when_required"

set -euxo pipefail
source /home/conda/.bashrc
source activate base
conda activate flatland-rl
python -m pip list
python evaluator.py
echo "\\ end evaluator/run.sh"
