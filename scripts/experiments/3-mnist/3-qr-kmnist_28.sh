#!/bin/bash
#SBATCH --job-name 3-qr-kmnist-28                   # Job name
#SBATCH --time 0-06:00                              # Runtime limit in D-HH:MM, minimum of 10 minutes
#SBATCH --mem=64000                                 # Memory pool for all cores in MB (see also --mem-per-cpu)
#SBATCH --output err_out/%x/%x_%A_%a.out            # File to which STDOUT will be written, %x inserts job name, %A inserts job id, %a inserts array id
#SBATCH --error err_out/%x/%x_%A_%a.err             # File to which STDERR will be written, %x inserts job name, %A inserts job id, %a inserts array id
#SBATCH --partition gpu_requeue,gpu,seas_gpu,mweber_gpu,gpu_h200 # Which partitions
#SBATCH --gres=gpu:1                                # Number of GPUs
#SBATCH --ntasks 1                                  # How many tasks (to run parallely)
#SBATCH --requeue                                   # Allow to be requeued
#SBATCH --account mweber_lab                        # Who to charge compute under
#SBATCH --mail-type ALL                             # When to mail
#SBATCH --mail-user jasonwang1@college.harvard.edu  # Who to mail
#SBATCH --array 1-10                                 # Submit a job array of 1-N jobs
#SBATCH --comment "comment"                         # Comment

index=$(($SLURM_ARRAY_TASK_ID - 1))
python -m kappakit.routines.upsample_with_diffusion \
    --upsample.dataset ./data/kmnist_28 \
    --upsample.model ./models/kmnist_28 \
    --upsample.x_0 "label_${index}" \
    --upsample.num_points 60000 \
    --upsample.diffusion_distance 1 \
    --upsample.timestep 100 \
    --upsample.batch_size 256 \
    --upsample.save_name "./data/kmnist_28_x0=${index}"
python -m kappakit.routines.estimate_curvature \
    --dataset.name "./data/kmnist_28_x0=${index}" \
    --output.name "./results/kmnist_28_x0=${index}_regression" \
    --dataset.eval_mode 1 \
    --method.name regression \
    --regression.num_neighbors 30000 \
    --regression.pca_num_neighbors 5000 \
    --regression.method gradient_descent