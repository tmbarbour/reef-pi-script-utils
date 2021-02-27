#!/bin/bash

echo "The 'reef-py' completion feature requires the REEF_PY_PATH environment variable to be set"
echo " "
echo "Adding REEF_PY_PATH environment variable to your ~/.bashrc file"
CURR_DIR=$(pwd)
echo "export REEF_PY_PATH=\"${CURR_DIR}\"">>~/.bashrc
echo "Adding command to source the completion scripts in your ~/.bashrc file so they are available in every bash session"
echo "source ${CURR_DIR}/_reef-pi">>~/.bashrc
echo "source ${CURR_DIR}/_reef-py">>~/.bashrc

source ${CURR_DIR}/_reef-pi
source ${CURR_DIR}/_reef-py

defaults=$(cat auth/reef_pi_secrets.py | grep reef-pi-password | wc -l)
if [[ $defaults -eq 1 ]]; then
    echo "***** You must update 'auth/reef_pi_secrets.py' with the correct userid/password before reef-py.py will work  ******"
fi
echo "Completion scripts installed"