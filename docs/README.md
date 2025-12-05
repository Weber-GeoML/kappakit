# Building the Docs

The documentation is built with [Sphinx](https://www.sphinx-doc.org/en/master/).

First, install Sphinx and the other requirements in your environment:
```bash
cd docs
pip install -r requirements.txt
```

To make the docs:

```bash
cd docs
make html
```

To live preview the docs:

```bash
cd docs
sphinx-autobuild source build/html
```

Then the docs will be available under ``docs/build/html/index.html``.