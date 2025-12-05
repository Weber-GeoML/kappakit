#!/bin/bash
#SBATCH --job-name 3-qr-mnist                       # Job name
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
#SBATCH --array 1-6                                 # Submit a job array of 1-N jobs
#SBATCH --comment "comment"                         # Comment

index=$(($SLURM_ARRAY_TASK_ID - 1))
if [ "$index" -eq 0 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name MNIST \
        --dataset.save_name data/mnist_12 \
        --dataset.num_points 60000 \
        --mnist.image_size 12
    python -m kappakit.routines.train_diffusion_model \
        --dataset.name ./data/mnist_12 \
        --train.num_epochs 20 \
        --train.batch_size 256 \
        --train.lr 0.001 \
        --train.model_architecture UNet \
        --train.image_size 12 \
        --train.image_channels 1 \
        --train.save_name models/mnist_12
fi
if [ "$index" -eq 1 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name KMNIST \
        --dataset.save_name data/kmnist_12 \
        --dataset.num_points 60000 \
        --kmnist.image_size 12
    python -m kappakit.routines.train_diffusion_model \
        --dataset.name ./data/kmnist_12 \
        --train.num_epochs 20 \
        --train.batch_size 256 \
        --train.lr 0.001 \
        --train.model_architecture UNet \
        --train.image_size 12 \
        --train.image_channels 1 \
        --train.save_name models/kmnist_12
fi
if [ "$index" -eq 2 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name FMNIST \
        --dataset.save_name data/fmnist_12 \
        --dataset.num_points 60000 \
        --fmnist.image_size 12
    python -m kappakit.routines.train_diffusion_model \
        --dataset.name ./data/fmnist_12 \
        --train.num_epochs 20 \
        --train.batch_size 256 \
        --train.lr 0.001 \
        --train.model_architecture UNet \
        --train.image_size 12 \
        --train.image_channels 1 \
        --train.save_name models/fmnist_12
fi
if [ "$index" -eq 3 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name MNIST \
        --dataset.save_name data/mnist_28 \
        --dataset.num_points 60000 \
        --mnist.image_size 28
    python -m kappakit.routines.train_diffusion_model \
        --dataset.name ./data/mnist_28 \
        --train.num_epochs 20 \
        --train.batch_size 256 \
        --train.lr 0.001 \
        --train.model_architecture UNet \
        --train.image_size 28 \
        --train.image_channels 1 \
        --train.save_name models/mnist_28
fi
if [ "$index" -eq 4 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name KMNIST \
        --dataset.save_name data/kmnist_28 \
        --dataset.num_points 60000 \
        --kmnist.image_size 28
    python -m kappakit.routines.train_diffusion_model \
        --dataset.name ./data/kmnist_28 \
        --train.num_epochs 20 \
        --train.batch_size 256 \
        --train.lr 0.001 \
        --train.model_architecture UNet \
        --train.image_size 28 \
        --train.image_channels 1 \
        --train.save_name models/kmnist_28
fi
if [ "$index" -eq 5 ]; then
    python -m kappakit.routines.create_dataset \
        --dataset.name FMNIST \
        --dataset.save_name data/fmnist_28 \
        --dataset.num_points 60000 \
        --fmnist.image_size 28
    python -m kappakit.routines.train_diffusion_model \
        --dataset.name ./data/fmnist_28 \
        --train.num_epochs 20 \
        --train.batch_size 256 \
        --train.lr 0.001 \
        --train.model_architecture UNet \
        --train.image_size 28 \
        --train.image_channels 1 \
        --train.save_name models/fmnist_28
fi