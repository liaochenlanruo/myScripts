#!/bin/bash

# mamba install parallel-fastq-dump 'sra-tools>=3.0.0'
# mamba install parallel

# 定义输入文件（每行一个SRR号）
INPUT_FILE="srr_list.txt"
OUTPUT_DIR="fastq_output"

# 创建输出目录
mkdir -p $OUTPUT_DIR

cat srr_list.txt | parallel -j 80 "fastq-dump --split-files --gzip {} -O fastq_output"
