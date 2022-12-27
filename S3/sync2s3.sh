#!/bin/bash
#
# configure your AWS environment and
# export AWS_PROFILE with that configuration
#
aws s3 sync data s3://wgs-pipeline-bucket
