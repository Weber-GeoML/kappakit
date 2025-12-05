#!/bin/bash
# sbatch scripts/experiments/1-noise_vs_samples/quad_reg/1-qr-sphere.sh
# sbatch scripts/experiments/1-noise_vs_samples/quad_reg/1-qr-torus.sh
# sbatch scripts/experiments/1-noise_vs_samples/quad_reg/1-qr-roll.sh
# sbatch scripts/experiments/1-noise_vs_samples/quad_reg/1-qr-paraboloid.sh

# sbatch scripts/experiments/1-noise_vs_samples/diffusion_map/1-dmap-sphere.sh
# sbatch scripts/experiments/1-noise_vs_samples/diffusion_map/1-dmap-torus.sh
# sbatch scripts/experiments/1-noise_vs_samples/diffusion_map/1-dmap-roll.sh
# sbatch scripts/experiments/1-noise_vs_samples/diffusion_map/1-dmap-paraboloid.sh

sbatch scripts/experiments/1-noise_vs_samples/interpolation_path/1-path-sphere.sh
sbatch scripts/experiments/1-noise_vs_samples/interpolation_path/1-path-torus.sh
sbatch scripts/experiments/1-noise_vs_samples/interpolation_path/1-path-roll.sh
sbatch scripts/experiments/1-noise_vs_samples/interpolation_path/1-path-paraboloid.sh

sbatch scripts/experiments/1-noise_vs_samples/quad_reg_diffusion/1-qrd-sphere.sh
sbatch scripts/experiments/1-noise_vs_samples/quad_reg_diffusion/1-qrd-torus.sh
sbatch scripts/experiments/1-noise_vs_samples/quad_reg_diffusion/1-qrd-roll.sh
sbatch scripts/experiments/1-noise_vs_samples/quad_reg_diffusion/1-qrd-paraboloid.sh

# sbatch scripts/experiments/2-intrinsic_vs_normal/2-qr.sh
# sbatch scripts/experiments/2-intrinsic_vs_normal/2-dmap.sh
sbatch scripts/experiments/2-intrinsic_vs_normal/2-path.sh
sbatch scripts/experiments/2-intrinsic_vs_normal/2-qrd.sh

sbatch scripts/experiments/4-bunny/4-bunny.sh

# sbatch scripts/experiments/3-mnist/prepare.sh
# sbatch scripts/experiments/3-mnist/3-qr-mnist_12.sh
# sbatch scripts/experiments/3-mnist/3-qr-kmnist_12.sh
# sbatch scripts/experiments/3-mnist/3-qr-fmnist_12.sh
# sbatch scripts/experiments/3-mnist/3-qr-mnist_28.sh
# sbatch scripts/experiments/3-mnist/3-qr-kmnist_28.sh
# sbatch scripts/experiments/3-mnist/3-qr-fmnist_28.sh