#!/bin/bash

MOUNT_DIR=/opt/kvstore
DATASET_DIR=${MOUNT_DIR}/kmer_dataset

declare -A DATASET_ARRAY

# wget https://sra-pub-run-odp.s3.amazonaws.com/sra/ERR4846928/ERR4846928
DATASET_ARRAY["D_MELANOGASTER"]=${DATASET_DIR}/ERR4846928.fastq

# wget https://sra-pub-run-odp.s3.amazonaws.com/sra/SRR1513870/SRR1513870
# sratoolkit/fastq-dump <SRA_FILE>
DATASET_ARRAY["F_VESCA"]=${DATASET_DIR}/SRR1513870.fastq

NUM_MCYCLES_PER_SEC=2600
NUM_THREADS=64
CHTKC_ARGS="-m 92G --count-max=4294967296"
MAX_K=32


chtkc_run() {
  GENOME=${1}
  FASTA_FILE=${DATASET_ARRAY[${GENOME}]}
  for k in $(seq 4 ${MAX_K}); do
    ./build/chtkco count -k ${k} -t ${NUM_THREADS} --fa ${FASTA_FILE} ${CHTKC_ARGS} |& tee chtkc_k${k}_t${NUM_THREADS}_${GENOME}.log;
  done
}

chtkc_get_mops() {
  GENOME=${1}
  for k in $(seq 4 ${MAX_K}); do
    CYCLES_PER_KMER=$(grep "cycles/kmer" chtkc_k${k}_t${NUM_THREADS}_${GENOME}.log | awk '{print $(NF-1)}')
    MOPS=$(echo "${NUM_MCYCLES_PER_SEC}/${CYCLES_PER_KMER}" | bc)
    echo "${k}, ${MOPS}" | tee -a summary_${GENOME}.csv
  done
}

get_chtkc_throughtput() {
  chtkc_run $1
  chtkc_get_mops $1
}

get_chtkc_throughtput "D_MELANOGASTER"
get_chtkc_throughtput "F_VESCA"
