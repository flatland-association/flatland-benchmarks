#!/bin/bash
set -euxo pipefail
( sleep 10 && \
rabbitmqctl add_user admin admin && \
rabbitmqctl set_user_tags admin administrator management && \
rabbitmqctl set_permissions -p / admin  ".*" ".*" ".*" ) & \
rabbitmq-server
