#!/bin/bash
#SBATCH --job-name 4-bunny                          # Job name
#SBATCH --time 2-00:00                              # Runtime limit in D-HH:MM, minimum of 10 minutes
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
#SBATCH --array 3-4                                 # Submit a job array of 1-N jobs
#SBATCH --comment "comment"                         # Comment

# Setup conda environment
conda init bash
source activate manifold-ml
module load cuda

index=$((SLURM_ARRAY_TASK_ID - 1))
if [ "$index" -eq 0 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name StanfordBunny \
        --dataset.save_name data/bunny_regression \
        --dataset.num_points 35947 \
        --bunny.rescale 10
    python -m kappakit.routines.estimate_curvature \
        --dataset.name "./data/bunny" \
        --output.name "./results/bunny_regression" \
        --dataset.eval_mode all \
        --method.name regression \
        --regression.radius "[0.25,0.5,0.75,1.0,1.25,1.5,1.75,2.0,2.25,2.5]" \
        --regression.pca_num_neighbors "[30]" \
        --regression.method numpy \
        --regression.intrinsic_dim 2
    python -m kappakit.routines.estimate_curvature \
        --dataset.name "./data/bunny_regression" \
        --output.name "./results/bunny_regression_auto" \
        --dataset.eval_mode all \
        --method.name regression_auto \
        --regression.pca_batch_size 1 \
        --regression.reg_batch_size 1 \
        --regression.min_pca_points 10 \
        --regression.min_reg_points 10 \
        --regression.max_pca_points 100 \
        --regression.max_reg_points 100 \
        --regression.intrinsic_dim 2

elif [ "$index" -eq 1 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name StanfordBunny \
        --dataset.save_name data/bunny_diffusion \
        --dataset.num_points 35947 \
        --bunny.rescale 10
    python -m kappakit.routines.estimate_curvature \
        --dataset.name "./data/bunny_diffusion" \
        --output.name "./results/bunny_diffusion" \
        --dataset.eval_mode all \
        --method.name diffusion_map \
        --diffusion_map.intrinsic_dim 2 \
        --diffusion_map.num_eigenfunctions 50 \
        --diffusion_map.c "-0.5" \
        --diffusion_map.num_neighbors 64 \
        --diffusion_map.initial_bandwidth_num_neighbors 32
elif [ "$index" -eq 2 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name StanfordBunny \
        --dataset.save_name data/bunny_regression_diffusion \
        --dataset.num_points 35947 \
        --bunny.rescale 10
    python -m kappakit.routines.train_diffusion_model \
        --dataset.name ./data/bunny_regression_diffusion \
        --train.num_epochs 300 \
        --train.batch_size 256 \
        --train.lr 0.001 \
        --train.model_architecture FCN \
        --train.ambient_dim 3 \
        --train.num_layers 6 \
        --train.width 1024 \
        --train.save_name models/bunny_regression_diffusion
    python -m kappakit.routines.estimate_curvature \
        --dataset.name "./data/bunny" \
        --output.name "./results/bunny_regression_diffusion" \
        --dataset.eval_mode all \
        --method.name regression_diffusion \
        --regression.radius 0.25 \
        --regression.pca_radius 0.1 \
        --regression.method numpy \
        --regression.intrinsic_dim 2 \
        --regression.model_path "./models/bunny_regression_diffusion" \
        --regression.model_type FCN \
        --regression.diffusion_distance 0.01 \
        --regression.diffusion_time 100 \
        --regression.num_interpolants 512
    python -m kappakit.routines.estimate_curvature \
        --dataset.name "./data/bunny_regression_diffusion" \
        --output.name "./results/bunny_regression_diffusion_auto" \
        --dataset.eval_mode all \
        --method.name regression_diffusion_auto \
        --regression.intrinsic_dim 2 \
        --regression.pca_batch_size 1 \
        --regression.reg_batch_size 1 \
        --regression.min_pca_points 10 \
        --regression.min_reg_points 10 \
        --regression.max_pca_points 100 \
        --regression.max_reg_points 100 \
        --regression.model_path "./models/bunny_regression_diffusion" \
        --regression.model_type FCN \
        --regression.diffusion_distance 0.01 \
        --regression.diffusion_time 100 \
        --regression.num_interpolants 512

elif [ "$index" -eq 3 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name StanfordBunny \
        --dataset.save_name data/bunny_interpolation \
        --dataset.num_points 35947 \
        --bunny.rescale 10
    python -m kappakit.routines.train_diffusion_model \
        --dataset.name ./data/bunny_interpolation \
        --train.num_epochs 300 \
        --train.batch_size 256 \
        --train.lr 0.001 \
        --train.model_architecture FCN \
        --train.ambient_dim 3 \
        --train.num_layers 6 \
        --train.width 1024 \
        --train.save_name models/bunny_interpolation
    python -m kappakit.routines.estimate_curvature \
        --dataset.name "./data/bunny_interpolation" \
        --output.name "./results/bunny_interpolation" \
        --dataset.eval_mode all \
        --method.name interpolation \
        --interpolation.model_path "./models/bunny_interpolation" \
        --interpolation.model_type FCN \
        --interpolation.distance 0.01 \
        --interpolation.num_interpolants 512 \
        --interpolation.diffusion_time 100 \
        --interpolation.intrinsic_dim 2 \
        --interpolation.radius 0.01
fi
