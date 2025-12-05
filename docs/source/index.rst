KappaKit
======================================

``kappakit`` is a library that provides a variety of methods to estimate the curvature of a dataset.

You can read our `paper <https://openreview.net/pdf?id=zu24PDRqvB>`_ for a technical introduction to the subject.

``kappakit`` supports the following curvature estimation routines:

1. Quadratic Regression (`Cao et al. 2021 <https://arxiv.org/abs/1905.10725>`_)
2. Diffusion Maps (`Jones 2024 <https://arxiv.org/abs/2411.04100v1>`_)
3. Quadratic Regression with Diffusion Model-Augmented Sampling (`Wang et al. 2025 <https://openreview.net/pdf?id=zu24PDRqvB>`_)
4. Geodesic Interpolation with Diffusion Model-Augmented Sampling (`Wang et al. 2025 <https://openreview.net/pdf?id=zu24PDRqvB>`_)

Installation
------------
From source:

.. code-block:: bash

   git clone https://github.com/Weber-GeoML/Curvature_Estimation.git
   pip install -e .

From pip:

.. code-block:: bash

   pip install kappakit

Quickstart
----------
You can reproduce the experiments described in our `paper <https://openreview.net/pdf?id=zu24PDRqvB>`_  through the shell scripts provided in the ``scripts/`` folder.

Contributing
------------
We welcome contributions! Please submit pull requests in our `GitHub <https://github.com/Weber-GeoML/Curvature_Estimation.git>`_.

Citation
--------
If you use our code or otherwise find this library useful, please cite our paper:

.. code-block:: text

   @article{wang2025kappakit,
     title={Curvature Estimation on Data Manifolds via Diffusion-augmented Sampling},
     author={Wang, Jason and Kiani, Bobak and Weber, Melanie},
     journal={},
     year={2025}
   }

.. toctree::
   :maxdepth: 2
   :hidden:

   self
   tutorial