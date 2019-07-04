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

def main():
    test_mpi()
    test_cuda()

if __name__ == '__main__':
    main()
