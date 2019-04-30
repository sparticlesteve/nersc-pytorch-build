import torch.distributed as dist

def main():
    dist.init_process_group(backend='mpi')
    rank = dist.get_rank()
    n_ranks = dist.get_world_size()
    print('MPI process group successfully initialized!',
          'World size: {0}, Rank: {1}'.format(n_ranks, rank))

if __name__ == '__main__':
    main()
