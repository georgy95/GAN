#!/usr/bin/env bash

usage () {
  echo "usage: tensorboard.sh [local | remote]

Use 'local' to view locally with a local data file, and 'remote' to
see logs on ML Engine.

Examples:
# view locally
./tensorboard.sh local
# view on ML Engine with optimized hyperparams
./tensorboard.sh remote
"

}

JOB_ID=gan_training_local_20190331_195336

if [[ $# < 1 ]]; then
  usage
  exit 1
fi

# set job vars
JOB_TYPE="$1"

if [[ ${JOB_TYPE} == "local" ]]; then

  tensorboard --logdir=trainer/jobs/${JOB_ID}/tensorboard \
    --port 8088 \
    --host localhost \
    --reload_interval=5 \

elif [[ ${JOB_TYPE} == "remote" ]]; then

  tensorboard --logdir=gs://gr-20190331/srgan/cloudml/jobs/${JOB_ID}/tensorboard/SRResNet_imagenet/ \
    --host localhost \
    --port 8088 \
    --reload_interval=5 \

else
  usage
fi

