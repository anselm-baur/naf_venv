# naf_venv
creates a virtual python environment and ipython kernel on desy naf

* configure interpreter and name in `setup.sh`
* add python packages to install to `my_pyenv/requirements.txt`
* `source setup.sh`

first time sourcing will install everything, from then on it only sources the environment

`WORK_DIR` is available as environment variable and contains the location of the repo directory on NAF. The idea is to develop the whole analysis in that directory, and have the environment setup script always accompanied. TODO: add a .gitigonre to exclude the virtualenvironment binaries from `my_pyenv/`. Only commit updates to the `my_pyenv/requirements.txt`
