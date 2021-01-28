#!/bin/bash

echo "Copying the reef-pi completion script to /usr/share/bash-completion/completions/reef-pi"
sudo cp _reefpi_db_completion.sh /usr/share/bash-completion/completions/reef-pi
source /usr/share/bash-completion/completions/reef-pi

echo "Completion script installed"