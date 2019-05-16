#!/usr/bin/env bash

usage () {
  echo "usage: mltrain.sh [local | remote | tune ]

Use 'local' to train locally with a local data file, and 'train' to
run on ML Engine. For ML Engine jobs the train and valid directories must reside on GCS.

Examples:
# train locally
./train.sh local
# train on ML Engine with hparms.py
./train.sh remote
# tune hyperparameters on ML Engine
./train.sh tune
"

}

date
TIME=`date +"%Y%m%d_%H%M%S"`
# BUCKET
BUCKET=gs://gr-20190331/srgan/cloudml
MODEL_TO_LOAD=${BUCKET}/jobs/rnn_training_remote_20181224_003615/checkpoints/checkpoint.0020-8.750572048.hdf5


if [[ $# < 1 ]]; then
  usage
  exit 1
fi

# set job vars
JOB_TYPE="$1"
EVAL="$2"
JOB_NAME=gan_training_${JOB_TYPE}_${TIME}
export JOB_NAME
REGION=europe-west1

if [[ ${JOB_TYPE} == "local" ]]; then

  gcloud ml-engine local train \
    --module-name trainer.train \
    --package-path ./trainer \
    -- \
    --train trainer/data/train \
    --validation trainer/data/valid \
    --test trainer/data/test \
    --scale 4 \
    --test_path trainer/data/test \
    --stage gan \
    --job-dir trainer/jobs/${JOB_NAME}/ \
    --job-type ${JOB_TYPE} \


elif [[ ${JOB_TYPE} == "remote" ]]; then

  gcloud ml-engine jobs submit training ${JOB_NAME} \
    --region ${REGION} \
    --job-dir ${BUCKET}/jobs/${JOB_NAME}/ \
    --module-name trainer.train \
    --package-path ./trainer \
    --config trainer/config/config_train.json \
    -- \
    --train gs://gr-20190331/srgan/data/train \
    --validation gs://gr-20190331/srgan/data/valid \
    --test gs://gr-20190331/srgan/data/test \
    --scale 4 \
    --test_path gs://gr-20190331/srgan/data/test \
    --stage gan \
    --job-type ${JOB_TYPE} \

elif [[ ${JOB_TYPE} == "tune" ]]; then

  gcloud ml-engine jobs submit training ${JOB_NAME} \
    --region ${REGION} \
    --job-dir ${BUCKET}/jobs/${JOB_NAME}/ \
    --module-name trainer.model \
    --package-path ./trainer \
    --config trainer/config/config_tune.json \
    -- \
    --job-type ${JOB_TYPE} \

else
  usage
fi

