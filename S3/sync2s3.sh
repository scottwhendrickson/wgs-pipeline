#!/bin/bash
#
# configure your AWS environment and
# export AWS_PROFILE with that configuration
#
# IMPORTANT! the bucketname below will need to have the unique
# identifier appended to the end of wgs-pipeline-bucket
# this can be found in the CloudFormation Outputs or in S3
# the actually bucket name will be something like wgs-pipeline-bucket-0c1753e0
# a successful sync is shown below

aws s3 sync data s3://wgs-pipeline-bucket

#aws s3 sync data s3://wgs-pipeline-bucket-0c1753e0
#upload: data/data/genome.fa.amb to s3://wgs-pipeline-bucket-0c1753e0/data/genome.fa.amb
#upload: data/data/mapped_reads/output to s3://wgs-pipeline-bucket-0c1753e0/data/mapped_reads/output
#upload: data/data/genome.fa.fai to s3://wgs-pipeline-bucket-0c1753e0/data/genome.fa.fai
#upload: data/data/genome.fa.ann to s3://wgs-pipeline-bucket-0c1753e0/data/genome.fa.ann
#upload: data/data/snakefiles/Snakefile to s3://wgs-pipeline-bucket-0c1753e0/data/snakefiles/Snakefile
#upload: data/data/snakefiles/config/environment.yaml to s3://wgs-pipeline-bucket-0c1753e0/data/snakefiles/config/environment.yaml
#upload: data/data/genome.fa.pac to s3://wgs-pipeline-bucket-0c1753e0/data/genome.fa.pac
#upload: data/data/genome.fa.sa to s3://wgs-pipeline-bucket-0c1753e0/data/genome.fa.sa
#upload: data/data/genome.fa to s3://wgs-pipeline-bucket-0c1753e0/data/genome.fa
#upload: data/data/genome.fa.bwt to s3://wgs-pipeline-bucket-0c1753e0/data/genome.fa.bwt
#upload: data/data/samples/A.fastq to s3://wgs-pipeline-bucket-0c1753e0/data/samples/A.fastq
#upload: data/data/samples/C.fastq to s3://wgs-pipeline-bucket-0c1753e0/data/samples/C.fastq
#upload: data/data/samples/B.fastq to s3://wgs-pipeline-bucket-0c1753e0/data/samples/B.fastq

