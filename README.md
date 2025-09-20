# nersc-pytorch-build

Automated build and test scripts for installing the NERSC-supported PyTorch software stack on Perlmutter GPU nodes. The repository wraps all of the configuration that is normally performed manually—loading environment modules, creating the conda environment, compiling source components, and installing companion packages—into a reproducible workflow that can be submitted as a Slurm batch job.

## Quick start

1. Clone this repository on a Perlmutter login node and change into it.
2. Update `config/base_config.sh` if you need to customize versions, install locations, or module choices (see [Configuration](#configuration)).
3. Run the installer script:

   ```bash
   ./install.sh
   ```

   The script executes the build steps `clean`, `env`, `pytorch`, `extras`, `apex`, `geometric`, and `mpi4py` by default, writing per-step logs to `logs/`.

   If you prefer to run the build non-interactively, the same script can be submitted through Slurm:

   ```bash
   sbatch install.sh
   ```

   When submitted this way, the job requests the GPU `regular` queue, and batch output is written alongside the step logs in `logs/`.

To rerun a subset of steps without cleaning, provide a custom `BUILD_STEPS` list when submitting, e.g.

```bash
BUILD_STEPS="pytorch extras" ./install.sh
```

The same override works when submitting with `sbatch`.

Each step automatically activates the conda environment when required.

## Configuration

All top-level settings live in `config/base_config.sh`.

| Setting | Description |
| --- | --- |
| `INSTALL_BASE` | Root installation directory. Defaults to `/global/common/software/nersc9` for the `swowner` account and `$SCRATCH/conda` for other users. |
| `INSTALL_NAME` | Folder name under `INSTALL_BASE` where this stack will be installed (`pytorch` by default). |
| `PYTHON_VERSION` | Python version used when creating the conda environment. |
| `PYTORCH_VERSION` / `PYTORCH_BRANCH` | Version (or git branch) of PyTorch that is installed either from wheels or source. |
| `PYTORCH_URL` | Git repository URL used for source builds. |
| `PYTORCH_INSTALL_OPTS` | Extra flags passed to `pip install` when installing the prebuilt wheel (defaults to the CUDA 12.9 NGC index). |
| `VISION_VERSION` / `VISION_BRANCH` | Version of `torchvision` that is built from source in the source build workflow. |
| `RESUME_PYTORCH_BUILD` | Set to `true` to reuse existing source trees instead of recloning. |
| `BUILD_DIR` | Scratch location that holds intermediate build artifacts. |
| `INSTALL_DIR` | Absolute path to the conda prefix that is created for the installation. |
| `USE_CRAY_COMPILER_WRAPPERS` | When `true`, switches compilation to use Cray wrappers (`cc`/`CC`). |
| `MAX_JOBS` | Parallelism hint for builds that respect the variable. |

The configuration script also loads all required Perlmutter modules (conda, cmake, PrgEnv-gnu, gcc-native/13.2, cudatoolkit/12.9, and nccl/2.24.3), exports common CUDA settings (e.g., `MPICH_GPU_SUPPORT_ENABLED=0`), validates dependencies, and prints a summary of the paths being used.

## Build steps

`install.sh` orchestrates the build process by calling the individual scripts in `builds/`. Steps can be reordered or omitted by editing the `BUILD_STEPS` variable before running the script or submitting it to Slurm.

| Step name | Script | Purpose |
| --- | --- | --- |
| `clean` | `builds/build_clean.sh` | Removes the build and install directories to guarantee a fresh start. |
| `env` | `builds/build_env.sh` | Creates the conda environment at `INSTALL_DIR` with the configured Python version. |
| `pytorch` | `builds/build_pytorch.sh` | Installs the official PyTorch wheel and `torchvision` from the configured index. |
| `pytorch_source` | `builds/build_pytorch_source.sh` | (Optional) Builds PyTorch and torchvision from source, generating wheels in the build directory. Enable by adding `pytorch_source` to `BUILD_STEPS`. |
| `extras` | `builds/build_extras.sh` | Installs commonly used scientific Python packages, Lightning, Ray, Hugging Face tooling, NVIDIA DALI, and other utilities. |
| `apex` | `builds/build_apex.sh` | Clones and builds NVIDIA Apex with the C++ and CUDA extensions enabled. |
| `geometric` | `builds/build_geometric.sh` | Compiles PyTorch Geometric and its dependencies from source for improved compatibility on Perlmutter. |
| `mpi4py` | `builds/build_mpi4py.sh` | Rebuilds `mpi4py` against the Cray MPI compiler wrapper. |
| `craydl` | `builds/build_craydl.sh` | (Optional) Installs the Cray Deep Learning plugin wheel. Add to `BUILD_STEPS` when needed. |

Each script writes detailed output to `logs/build_<step>.log`. The reusable logging helpers in `utils/logging.sh` honour the `LOG_LEVEL` environment variable (default: INFO).

## Running tests

Once the environment has been built, end-to-end validation can be submitted with:

```bash
sbatch run_tests.sh
```

The test job loads the same configuration as the build, clones the [`nersc-pytorch-testing`](https://github.com/sparticlesteve/nersc-pytorch-testing) repository, activates the freshly built environment, and executes the GPU regression test suite on two nodes.

## Repository layout

```
README.md              High-level documentation and workflow overview
install.sh             Slurm batch script that orchestrates the build steps
run_tests.sh           Slurm batch script that launches the automated test suite
config/base_config.sh  Central configuration values and environment module setup
builds/                Individual step implementations
utils/                 Logging, validation, and environment helper functions
```

## Tips and troubleshooting

- The `clean` step waits five seconds before deleting directories to avoid accidental removal; use `BUILD_STEPS` to skip it when you need an incremental rebuild.
- To inspect module choices or update CUDA/NCCL versions, edit the `module load` lines near the end of `config/base_config.sh`.
- Source builds can require significant time. Consider enabling `RESUME_PYTORCH_BUILD=true` to reuse previous clones when experimenting.
- All scripts assume they are run on Perlmutter. If you intend to adapt them to another system, update the module loads, CUDA architecture list, and the Cray-specific options in the configuration file.
