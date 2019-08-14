#!/bin/bash

module load esslurm
#salloc -C gpu --gres=gpu:1 -c 10 -t 4:00:00
#salloc -C gpu --gres=gpu:8 --exclusive -t 2:00:00
srun -C gpu -N 1 -c 80 --gres=gpu:8 --exclusive -t 2:00:00 --pty bash -l
