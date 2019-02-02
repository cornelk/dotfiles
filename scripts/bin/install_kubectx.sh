#!/usr/bin/env bash

mkdir src 2> /dev/null
cd src

git clone https://github.com/ahmetb/kubectx
ln -s $PWD/kubectx/kubectx ~/bin/kubectx
ln -s $PWD/kubectx/kubens ~/bin/kubens

mkdir -p ~/.config/fish/completions
ln -s $PWD/kubectx/completion/kubectx.fish ~/.config/fish/completions/
ln -s $PWD/kubectx/completion/kubens.fish ~/.config/fish/completions/
