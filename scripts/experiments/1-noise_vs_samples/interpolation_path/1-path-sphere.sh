#!/bin/bash
#SBATCH --job-name 1-path-sphere                    # Job name
#SBATCH --time 0-12:00                              # Runtime limit in D-HH:MM, minimum of 10 minutes
#SBATCH --mem=8000                                  # Memory pool for all cores in MB (see also --mem-per-cpu)
#SBATCH --output err_out/%x/%x_%A_%a.out            # File to which STDOUT will be written, %x inserts job name, %A inserts job id, %a inserts array id
#SBATCH --error err_out/%x/%x_%A_%a.err             # File to which STDERR will be written, %x inserts job name, %A inserts job id, %a inserts array id
#SBATCH --partition gpu_requeue,gpu,seas_gpu,mweber_gpu,gpu_h200 # Which partitions
#SBATCH --gres=gpu:1                                # Number of GPUs
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
module load cuda

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
    --dataset.name Sphere \
    --dataset.save_name "data/sphere_N=${num_points}_s=${noise}_interpolation" \
    --dataset.num_points ${num_points} \
    --dataset.noise ${noise} \
    --dataset.skip_basis true \
    --sphere.radius 1 \
    --sphere.intrinsic_dim 2 \
    --sphere.ambient_dim 3
python -m kappakit.routines.train_diffusion_model \
    --dataset.name "./data/sphere_N=${num_points}_s=${noise}_interpolation" \
    --dataset.num_points "${num_points}" \
    --train.num_epochs 300 \
    --train.batch_size 256 \
    --train.lr 0.001 \
    --train.model_architecture FCN \
    --train.ambient_dim 3 \
    --train.num_layers 6 \
    --train.width 1024 \
    --train.save_name "./models/sphere_N=${num_points}_s=${noise}_interpolation"
python -m kappakit.routines.estimate_curvature \
    --dataset.name "./data/sphere_N=${num_points}_s=${noise}_interpolation" \
    --output.name "./results/sphere_N=${num_points}_s=${noise}_interpolation" \
    --dataset.eval_mode all \
    --method.name interpolation \
    --interpolation.model_path "./models/sphere_N=${num_points}_s=${noise}_interpolation" \
    --interpolation.model_type FCN \
    --interpolation.distance 0.3 \
    --interpolation.num_interpolants 100 \
    --interpolation.diffusion_time 100 \
    --interpolation.intrinsic_dim 2 \
    --interpolation.radius 0.4 \
    --interpolation.use_true_tangents true