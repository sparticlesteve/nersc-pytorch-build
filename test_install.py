import argparse

import torch
import torch.distributed as dist

def test_mpi():
    dist.init_process_group(backend='mpi')
    rank = dist.get_rank()
    n_ranks = dist.get_world_size()
    print('MPI process group successfully initialized!',
          'World size: {0}, Rank: {1}'.format(n_ranks, rank))

def test_cuda():
    print('CUDA available:', torch.cuda.is_available())
    print('CUDA device:', torch.cuda.current_device())

def test_torchvision():
    import torchvision
    print(torchvision)

def test_geometric():
    import torch_geometric
    print(torch_geometric)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--mpi', action='store_true')
    parser.add_argument('--cuda', action='store_true')
    parser.add_argument('--vision', action='store_true')
    parser.add_argument('--geometric', action='store_true')
    parser.add_argument('--all', action='store_true')
    args = parser.parse_args()

    # Run the tests
    if args.mpi or args.all:
        test_mpi()
    if args.cuda or args.all:
        test_cuda()
    if args.vision or args.all:
        test_torchvision()
    if args.geometric or args.all:
        test_geometric()

if __name__ == '__main__':
    main()
