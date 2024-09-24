# Wanderwege

Prerequisites: Python 3.12.2

We use ([Conda]https://conda.io/projects/conda/en/latest/user-guide/install/index.html) to cleanly manage the installation, updating, and handling of software packages and dependencies.

A new environment (www) can be created with all the necessary libraries by executing the environment.yaml file which is included in the repository:

```bash
conda env create -f environment.yaml
```

Activate the new environment with:

```bash
conda activate www
```

For access to the Azure Cloud to work, the db_config.json file must be placed in the Wanderwege/config folder. Additionally, the user's IP address must be registered in Azure.
