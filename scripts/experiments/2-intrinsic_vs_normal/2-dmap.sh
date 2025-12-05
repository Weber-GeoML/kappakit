#!/bin/bash
#SBATCH --job-name 2-dmap                           # Job name
#SBATCH --time 0-12:00                              # Runtime limit in D-HH:MM, minimum of 10 minutes
#SBATCH --mem=64000                                 # Memory pool for all cores in MB (see also --mem-per-cpu)
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
intrinsic_dim_array=(2 4 8 16 32)
normal_dim_array=(2 4 8 16 32)
intrinsic_dim_expanded=()
normal_dim_expanded=()
for intrinsic_dim in "${intrinsic_dim_array[@]}"; do
  for normal_dim in "${normal_dim_array[@]}"; do
    intrinsic_dim_expanded+=($intrinsic_dim)
    normal_dim_expanded+=($normal_dim)
  done
done
intrinsic_dim=${intrinsic_dim_expanded[$index]}
normal_dim=${normal_dim_expanded[$index]}

echo "index=${index},intrinsic_dim=${intrinsic_dim},normal_dim=${normal_dim}"

python -m kappakit.routines.create_dataset \
    --dataset.name Paraboloid \
    --dataset.save_name "data/paraboloid_d=${intrinsic_dim}_n=${normal_dim}_diffusion" \
    --dataset.num_points 5000 \
    --dataset.noise 0 \
    --dataset.skip_basis true \
    --paraboloid.intrinsic_dim ${intrinsic_dim} \
    --paraboloid.ambient_dim $(($intrinsic_dim+$normal_dim)) \
    --paraboloid.sff ${intrinsic_dim} \
    --paraboloid.radius 1
python -m kappakit.routines.estimate_curvature \
    --dataset.name "./data/paraboloid_d=${intrinsic_dim}_n=${normal_dim}_diffusion" \
    --output.name "./results/paraboloid_d=${intrinsic_dim}_n=${normal_dim}_diffusion" \
    --dataset.eval_mode all \
    --method.name diffusion_map \
    --diffusion_map.intrinsic_dim 2 \
    --diffusion_map.num_eigenfunctions 50 \
    --diffusion_map.c "-0.5" \
    --diffusion_map.num_neighbors 64 \
    --diffusion_map.initial_bandwidth_num_neighbors 32