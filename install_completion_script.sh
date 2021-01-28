#!/bin/bash

echo "Copying the reef-pi completion script to /usr/share/bash-completion/completions/_reef-pi"
sudo cp _reef-pi /usr/share/bash-completion/completions/
source /usr/share/bash-completion/completions/_reef-pi

echo "Completion script installed"