#!/usr/bin/env bash

set -euo pipefail

put_dotfiles() {
  ln -s .tmux.conf ~/
  ln -s .selected_editor ~/
}

all() {
  put_dotfiles
}

"$@" || exit