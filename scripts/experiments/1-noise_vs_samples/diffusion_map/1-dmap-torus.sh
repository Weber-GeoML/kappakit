#!/bin/bash
#SBATCH --job-name 1-dmap-torus                     # Job name
#SBATCH --time 0-12:00                              # Runtime limit in D-HH:MM, minimum of 10 minutes
#SBATCH --mem=8000                                  # Memory pool for all cores in MB (see also --mem-per-cpu)
#SBATCH --output err_out/%x/%x_%A_%a.out            # File to which STDOUT will be written, %x inserts job name, %A inserts job id, %a inserts array id
#SBATCH --error err_out/%x/%x_%A_%a.err             # File to which STDERR will be written, %x inserts job name, %A inserts job id, %a inserts array id
#SBATCH --partition serial_requeue,mweber_compute   # Which partitions
#SBATCH --ntasks 1                                  # How many tasks (to run parallely)
#SBATCH --requeue                                   # Allow to be requeued
#SBATCH --account mweber_lab                        # Who to charge compute under
#SBATCH --mail-type ALL                             # When to mail
#SBATCH --mail-user jasonwang1@college.harvard.edu  # Who to mail
#SBATCH --array 1-25                                # Submit a job array of 1-N jobs
#SBATCH --comment "comment"                         # Comment

# Setup conda environment
conda init bash
source activate manifold-ml
# module load cuda

index=$(($SLURM_ARRAY_TASK_ID - 1))
num_points_array=(250 500 1000 2500 5000)
noise_array=(0 0.005 0.01 0.05 0.1)
num_points_expanded=()
noise_expanded=()
for num_points in "${num_points_array[@]}"; do
  for noise in "${noise_array[@]}"; do
    num_points_expanded+=($num_points)
    noise_expanded+=($noise)
  done
done
num_points=${num_points_expanded[$index]}
noise=${noise_expanded[$index]}

echo "index=${index},num_points=${num_points},noise=${noise}"

python -m kappakit.routines.create_dataset \
    --dataset.name Torus \
    --dataset.save_name "data/torus_N=${num_points}_s=${noise}_diffusion" \
    --dataset.num_points ${num_points} \
    --dataset.noise ${noise} \
    --dataset.skip_basis true \
    --torus.major_radius 2 \
    --torus.minor_radius 1 \
    --torus.ambient_dim 3
python -m kappakit.routines.estimate_curvature \
    --dataset.name "./data/torus_N=${num_points}_s=${noise}_diffusion" \
    --output.name "./results/torus_N=${num_points}_s=${noise}_diffusion" \
    --dataset.eval_mode all \
    --method.name diffusion_map \
    --diffusion_map.intrinsic_dim 2 \
    --diffusion_map.num_eigenfunctions 50 \
    --diffusion_map.c "-0.5" \
    --diffusion_map.num_neighbors 64 \
    --diffusion_map.initial_bandwidth_num_neighbors 32