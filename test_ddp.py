"""
Test of PyTorch DistributedDataParallel for Cori GPU installations
"""

import argparse

import torch
import torch.distributed as dist
import torchvision

def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument('--ranks-per-node', type=int, default=8)
    return parser.parse_args()

def main():
    args = parse_args()

    # Initialized distributed library
    dist.init_process_group(backend='mpi')
    rank, n_ranks = dist.get_rank(), dist.get_world_size()
    local_rank = rank % args.ranks_per_node
    print('Initialized rank', rank, 'size', n_ranks)

    torch.cuda.set_device(local_rank)
    device = torch.device('cuda', local_rank)

    # Random number dataset
    print('Generating a batch of data')
    batch_size, n_features, n_classes = (32, 32, 10)
    x = torch.randn((batch_size, n_features)).to(device)
    y = torch.randint(n_classes, (batch_size,)).to(device)

    # Construct a simple model
    print('Constructing model')
    #model = torch.nn.Linear(n_features, n_classes).to(device)
    model = torchvision.models.resnet50().to(device)

    # Wrap model for distributed training
    model = torch.nn.parallel.DistributedDataParallel(
        model, device_ids=[local_rank], output_device=local_rank)

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
