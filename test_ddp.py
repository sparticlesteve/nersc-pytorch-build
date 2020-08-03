"""
Test of PyTorch DistributedDataParallel for Cori GPU installations
"""

import os
import argparse

import torch
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel
import torchvision

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--ranks-per-node', type=int, default=8)
    parser.add_argument('--backend', default='mpi',
                        choices=['mpi', 'nccl-file', 'gloo-file'])
    parser.add_argument('--gpu', action='store_true', help='Use GPUs')
    return parser.parse_args()

def init_workers_gloo_file():
    rank = int(os.environ['SLURM_PROCID'])
    n_ranks = int(os.environ['SLURM_NTASKS'])
    sync_file_dir = '%s/tmp' % os.environ['SCRATCH']
    os.makedirs(sync_file_dir, exist_ok=True)
    sync_file = 'file://%s/pytorch_sync_%s' % (
        sync_file_dir, os.environ['SLURM_JOB_ID'])
    dist.init_process_group(backend='gloo', world_size=n_ranks, rank=rank,
                            init_method=sync_file)
    return rank, n_ranks

def init_workers_nccl_file():
    rank = int(os.environ['SLURM_PROCID'])
    n_ranks = int(os.environ['SLURM_NTASKS'])
    sync_file_dir = '%s/tmp' % os.environ['SCRATCH']
    os.makedirs(sync_file_dir, exist_ok=True)
    sync_file = 'file://%s/pytorch_sync_%s' % (
        sync_file_dir, os.environ['SLURM_JOB_ID'])
    dist.init_process_group(backend='nccl', world_size=n_ranks, rank=rank,
                            init_method=sync_file)
    return rank, n_ranks

def init_workers_mpi():
    dist.init_process_group(backend='mpi')
    rank = dist.get_rank()
    n_ranks = dist.get_world_size()
    return rank, n_ranks

def main():
    args = parse_args()

    # Initialize distributed library
    if args.backend == 'mpi':
        init_func = init_workers_mpi
    elif args.backend == 'gloo-file':
        init_func = init_workers_gloo_file
    else:
        init_func = init_workers_nccl_file
    rank, n_ranks = init_func()
    local_rank = rank % args.ranks_per_node
    print('Initialized rank', rank, 'local-rank', local_rank, 'size', n_ranks)

    if args.gpu:
        torch.cuda.set_device(local_rank)
        device = torch.device('cuda', local_rank)
    else:
        device = torch.device('cpu')

    # Random number dataset
    print('Generating a batch of data')
    batch_size = 32
    sample_shape = [3, 224, 224]
    n_classes = 32
    x = torch.randn([batch_size] + sample_shape).to(device)
    y = torch.randint(n_classes, (batch_size,)).to(device)

    # Construct a simple model
    print('Constructing model')

    # Single-layer CNN works with hidden size 256, fails with 512
    #hidden_size = 256 # Error if 512
    #model = torch.nn.Sequential(
    #    torch.nn.Conv2d(3, hidden_size, kernel_size=3),
    #    torch.nn.Conv2d(hidden_size, n_classes, kernel_size=3),
    #    torch.nn.AdaptiveAvgPool2d(1),
    #    torch.nn.Flatten()).to(device)

    # ResNet50
    model = torchvision.models.resnet50(num_classes=n_classes).to(device)

    # Wrap model for distributed training
    device_ids = [device] if args.gpu else None
    model = DistributedDataParallel(model, device_ids=device_ids)

    if rank == 0:
        print(model)

    # Loss function
    loss_fn = torch.nn.CrossEntropyLoss().to(device)

    # Optimizer
    optimizer = torch.optim.SGD(model.parameters(), lr=0.01)

    # Training
    print('Performing one training step')
    batch_output = model(x)
    loss = loss_fn(batch_output, y)
    loss.backward()
    optimizer.step()

    print('Finished')

if __name__ == '__main__':
    main()
