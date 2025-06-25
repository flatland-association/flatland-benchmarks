# https://stackoverflow.com/questions/21953835/run-subprocess-and-print-output-to-logging
import logging
import subprocess
from io import TextIOWrapper, BytesIO
from typing import List, Optional

logger = logging.getLogger(__name__)


# https://stackoverflow.com/questions/21953835/run-subprocess-and-print-output-to-logging
def log_subprocess_output(pipe, level=logging.DEBUG, label="", collect: bool = False) -> Optional[List[str]]:
    s = []
    for line in pipe.readlines():
        logger.log(level, "[from subprocess %s] %s", label, line)
        if collect:
            s.append(line)
    if collect:
        return s
    return None


def exec_with_logging(exec_args: List[str], log_level_stdout=logging.DEBUG, log_level_stderr=logging.WARN, collect: bool = False):
    logger.debug(f"/ Start %s", exec_args)
    try:
        print(exec_args)
        proc = subprocess.Popen(exec_args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        stdout, stderr = proc.communicate()
        stdo = log_subprocess_output(TextIOWrapper(BytesIO(stdout)), level=log_level_stdout, label=str(exec_args), collect=collect)
        stde = log_subprocess_output(TextIOWrapper(BytesIO(stderr)), level=log_level_stderr, label=str(exec_args), collect=collect)
        logger.debug("\\ End %s", exec_args)
        if proc.returncode != 0:
            raise RuntimeError(f"Failed to run {exec_args} with returncode={proc.returncode}. Stdout={stdout}. Stderr={stderr}")
        return stdo, stde
    except (OSError, subprocess.CalledProcessError) as exception:
        print("err")
        print(stderr)
        logger.error(stderr)
        raise RuntimeError(f"Failed to run {exec_args}. Stdout={stdout}. Stderr={stderr}") from exception
