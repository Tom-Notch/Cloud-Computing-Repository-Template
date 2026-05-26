<h1 align="center">Cloud Computing Repository Template</h1>

<p align="center">
  <em>A GitHub repository template for HPC and cloud workloads with Docker, Singularity, and Slurm</em>
</p>

<p align="center">
  <a href="https://github.com/Tom-Notch/Cloud-Computing-Repository-Template/actions/workflows/pre-commit.yml"><img src="https://github.com/Tom-Notch/Cloud-Computing-Repository-Template/actions/workflows/pre-commit.yml/badge.svg" alt="pre-commit"></a>
  <img src="https://img.shields.io/badge/Docker-Recommended-2496ed?logo=docker&logoColor=white" alt="Docker">
  <img src="https://img.shields.io/badge/Singularity-HPC-8a2be2?logo=linux&logoColor=white" alt="Singularity">
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT">
</p>

A GitHub repository template for cloud computing and HPC workloads. Combines Docker (for local/cloud machines) with Singularity/Apptainer (for HPC clusters where Docker is unavailable), plus Slurm job scripts.

> **TLDR:** Search for `todo` and update all occurrences to your desired name. Docker and Singularity are optional if all dependencies can be installed directly on the HPC shell.

## Dependencies

- [Docker](https://docs.docker.com/get-docker/) — for local development and building images
- [Singularity/Apptainer](https://apptainer.org/) — for running on HPC clusters

## Usage

### Base Repository

1. Change [LICENSE](LICENSE) if necessary
1. Modify [.pre-commit-config.yaml](.pre-commit-config.yaml) according to your needs
1. Modify/add GitHub workflow status badges in [README.md](README.md)

### Docker Config

> Continue on a machine where you have Docker permission — HPC clusters usually restrict Docker access for security reasons.

1. Fill in all `todo-*` placeholders directly in [.env.example](.env.example) and commit — these are project-level constants, not secrets

   | Placeholder | Description |
   |-------------|-------------|
   | `todo-docker-user` | Your Docker Hub account username |
   | `todo-base-image` | Base image the Dockerfile builds from (e.g. `nvidia/cuda:13.0.0-cudnn-devel-ubuntu24.04`) |
   | `todo-image-name` | Name of the image you are building |
   | `todo-image-user` | Default user inside the image, used to determine the home folder |

1. Copy [.env.example](.env.example) to `.env` and add any user-specific secrets or local overrides:

   ```shell
   cp .env.example .env
   ```

   > `.env` is gitignored and will NOT be committed — it is the right place for secrets and per-user values. It is loaded automatically by docker compose.

1. Modify the service name from `todo-service-name` to your service name in [docker-compose.yml](docker-compose.yml), add additional volume mounting options such as dataset directories

1. Update [Dockerfile](docker/latest/Dockerfile) and [.dockerignore](.dockerignore) — the existing Dockerfile includes screen & tmux config, oh-my-zsh, cmake, and other basic tools

1. Run scripts to build, test, and push:

   | Script | Action |
   |--------|--------|
   | [build_docker_image.sh](scripts/build_docker_image.sh) | Build and test the image locally (uses `buildx` for multi-arch) |
   | [run_docker_container.sh](scripts/run_docker_container.sh) | Run and test a built image (`docker compose up -d` also works) |
   | [push_docker_image.sh](scripts/push_docker_image.sh) | Push the multi-arch image to Docker Hub |

   > The service mounts the entire repository onto `CODE_FOLDER` inside the container — modifications inside are reflected outside, useful for VS Code remote development.

### Singularity Config

> Continue on the actual HPC cluster environment.

1. Run [pull_singularity_image.sh](scripts/pull_singularity_image.sh) to build the Singularity image locally from the Docker image you pushed

   > You should see `todo-image-name_latest.def` after a successful build.

1. Run [run_singularity_instance.sh](scripts/run_singularity_instance.sh) to test the image

   - Add additional volume bind options (e.g. dataset directories) — define them in `.env`, then export via [variables.sh](scripts/variables.sh) using `resolve_host_path` to convert relative paths to absolute paths
   - Singularity instances have less environment isolation than Docker containers by default unless you pass the additional flags shown in the script

### Job Config

1. Modify job specifications under `jobs/`

   <details>
   <summary>Slurm tips</summary>

   - Query your cluster's partition layout with `sinfo`
   - Tie resources to tasks for easy scaling: `--ntasks-per-node`, `--gpus-per-task`, `--cpus-per-task`, `--mem-per-gpu`
   - All jobs use `-l` (login) in the shebang so any command available in your login shell also works as a job

   </details>

1. Submit and monitor jobs:

   ```shell
   sbatch jobs/your-cluster/your-job.job
   ```

   > Output logs appear as `todo_your_job_name_<slurm_job_id>.out` in the repository root.

1. Recommend [turm](https://github.com/kabouzeid/turm) for job monitoring — `turm -u your-slurm-user`

## Developer Quick Start

```shell
bash scripts/dev_setup.sh
```

## Maintainer

[Mukai (Tom Notch) Yu](mailto:mukaiy@andrew.cmu.edu)
