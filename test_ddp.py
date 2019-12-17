"""
Test of PyTorch DistributedDataParallel for Cori GPU installations
"""

import os
import argparse

import torch
import torch.distributed as dist
import torchvision

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--ranks-per-node', type=int, default=8)
    parser.add_argument('--backend', default='mpi',
                        choices=['mpi', 'nccl-file', 'gloo-file'])
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

    torch.cuda.set_device(local_rank)
    device = torch.device('cuda', local_rank)

    # Random number dataset
    print('Generating a batch of data')
    batch_size = 32
    sample_shape = [3, 224, 224]
    n_classes = 32
    #batch_size, n_features, n_classes = (32, 32, 10)
    #x = torch.randn((batch_size, n_features)).to(device)
    x = torch.randn([batch_size] + sample_shape).to(device)
    y = torch.randint(n_classes, (batch_size,)).to(device)

    # Construct a simple model
    print('Constructing model')
    #model = torch.nn.Linear(n_features, n_classes).to(device)
    model = torchvision.models.resnet50().to(device)

    # Wrap model for distributed training
    model = torch.nn.parallel.DistributedDataParallel(
        model, device_ids=[local_rank], output_device=local_rank)

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
