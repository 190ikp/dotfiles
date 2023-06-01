#!/usr/bin/env bash

set -euo pipefail

put_dotfiles() {
  mkdir ~/.local/bin
  source ~/.profile

  ln -s .tmux.conf ~/
  ln -s .selected_editor ~/
}

setup_py() {
  sudo apt update
  sudo apt upgrade -y
  command -v pip >/dev/null || sudo apt install -y python3-pip
  pip install -U pip

  curl https://pyenv.run | bash
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
  echo 'eval "$(pyenv init -)"' >> ~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
  echo 'eval "$(pyenv init -)"' >> ~/.profile
  source ~/.bashrc
  cd .pyenv
  src/configure
  make -C src
  cd ~/

  pip install --user pipenv
  echo 'eval "$(_PIP_COMPLETE=bash_source pip completion --bash)"' >> ~/.bashrc
  echo 'eval "$(_PIPENV_COMPLETE=bash_source "$HOME/.local/bin/pipenv")"' >> ~/.bashrc
  echo 'export PIPENV_IGNORE_VIRTUALENVS=1' >> ~/.bashrc
  echo 'export PIPENV_VENV_IN_PROJECT=1' >> ~/.bashrc

}

setup_hs() {
  # install GHCup
  export BOOTSTRAP_HASKELL_NONINTERACTIVE=1
  export BOOTSTRAP_HASKELL_ADJUST_BASHRC=1
  curl -fsSL https://get-ghcup.haskell.org | sh
  echo 'eval "$(stack --bash-completion-script stack)"' >> ~/.bashrc
  source ~/.bashrc
}

install_tools() {
  stack update
  stack install ShellCheck
  # install pandoc + LuaLaTeX
  stack install pandoc-cli
  stack install pandoc-crossref
  stack install citeproc
}

all() {
  put_dotfiles
  setup_py
  setup_hs
}

"$@" || exit