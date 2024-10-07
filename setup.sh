#!/bin/bash



### configuration
PYENV="my_pyenv" # name of virtual environment (needs to have the same name as directory with requirements.txt)
USE_CVMFS="false" # source a base environment from CVMFS
release="light-2403-persian" # basf2 version to source (used only if USE_CVMFS is true)
PYTHON_INTERPRETER="/usr/bin/python3" # ignored when USE_CVMFS is true
UPDATE="false" # if you want to update the python virtualenvironment set this to true, but set this to flase to not always check the python packages
### 


# make sure we have everythin we have in our .bashrc
source ${HOME}/.bashrc

# Enable alias expansion
shopt -s expand_aliases

# get the current location
location="$(cd -P "$(dirname "${_src}")" && pwd)"

# set it as working directory
export WORK_DIR="$location"


# cvmfs and basf2 release used for root and python
CVMFS=/cvmfs/belle.cern.ch # CVMFS directory to source

if [ "${USE_CVMFS}" == "true" ]; then
	# this provides our base python interpreter
	. ${CVMFS}/tools/b2setup $release
	alias ENV_PYTHON=$(which python3)
else
	# lets use as python interpreter what we defined
	alias ENV_PYTHON=${PYTHON_INTERPRETER}
fi

# change to our tau working directory
cd ${WORK_DIR}

# install the virtual python env if not installed
if [[ ! -d "${PYENV}/bin" || "${UPDATE}" == "true" ]]; then
 	# lets firt update pip
 	ENV_PYTHON -m pip install --upgrade pip

   	ENV_PYTHON -m pip install virtualenv
    	echo "install virtual environment ${PYENV}"
    	ENV_PYTHON -m virtualenv ${PYENV}

	# activate the virtual python env and install necessary packages if required
	source ${PYENV}/bin/activate
	python3 -m pip install -r ${PYENV}/requirements.txt

else
	# activate the virtual python env and install necessary packages if required
	source ${PYENV}/bin/activate
fi

# add the WORK_DIR to the PYTHONPATH variable
export PYTHONPATH="${WORK_DIR}:${PYTHONPATH}"


if [ ! -d "${HOME}/.local/share/jupyter/kernels/${PYENV}" ]; then
	
    # install and configure ipython kernel
	echo "setting up ipykernel"
    EXPORT_ENVS="--env WORK_DIR ${WORK_DIR} \
                 --env PYTHONPATH ${PYTHONPATH} "
    # only add the LD_LIBRARY_PATH if it is set
    if [ ${LD_LIBRARY_PATH} ]; then
        EXPORT_ENVS="--env  LD_LIBRARY_PATH ${LD_LIBRARY_PATH} ${EXPORT_ENVS}"
    fi
	# use the default python to install into the NAFs standard python to access kernel on JHUB
	python3 -m ipykernel install --user --name=${PYENV} ${EXPORT_ENVS}
fi

echo "set up ${PYENV} finished!"

