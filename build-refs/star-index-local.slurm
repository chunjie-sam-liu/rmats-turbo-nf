#!/usr/bin/env bash

#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=build-index.slurm
#SBATCH --output=test.slurm-%j.out
#SBATCH --error=test.slurm-%j.err
#SBATCH --mail-user=chunjie.sam.liu@gmail.com
#SBATCH --mail-type=ALL

bash build-refs/star-index-local.sh