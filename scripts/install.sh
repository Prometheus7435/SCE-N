#!/usr/bin/env bash

## scripts/install.sh <hostname> <username>
## Ex. sh scripts/install.sh starbase starfleet

set -euo pipefail

TARGET_HOST="${1:-}"
TARGET_USER="${2:-shyfox}"

GIT_REPO="Prometheus7435/SCE-N.git"

if [ ! -d "$HOME/Zero/nix-config/.git" ]; then
  git clone "https://github.com/$GIT_REPO" "$HOME/Zero/nix-config"
fi

pushd "$HOME/Zero/nix-config"

if [ ! -e "hosts/${TARGET_HOST}/disks.nix" ]; then
  echo "ERROR! $(basename "${0}") could not find the required nixos/${TARGET_HOST}/disks.nix"
  exit 1
fi

# if [ "$(id -u)" -eq 0 ]; then
#   echo "ERROR! $(basename "${0}") should be run as a regular user"
#   exit 1
# fi

echo "WARNING! The disks in ${TARGET_HOST} are about to get wiped"
echo "         NixOS will be re-installed"
echo "         This is a destructive operation"
echo
read -p "Are you sure? [y/N]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    sudo true

    sudo nix run github:nix-community/disko \
	 --extra-experimental-features 'nix-command flakes' \
	 --no-write-lock-file \
	 -- \
	 --mode zap_create_mount \
	 "hosts/${TARGET_HOST}/disks.nix"

    sudo nixos-install --no-root-password --flake ".#${TARGET_HOST}"

    # Rsync my nix-config to the target install
    # mkdir -p ~/.local/state/nix/profiles
    mkdir -p "/mnt/home/${TARGET_USER}/Zero/nix-config"
    # rsync -a --delete "${PWD}/" "/mnt/home/${TARGET_USER}/Zero/nix-config/"

    # Rsync nix-config to the target install and set the remote origin to SSH.
    rsync -a --delete "$HOME/Zero/" "/mnt/home/$TARGET_USER/Zero/"
    pushd "/mnt/home/$TARGET_USER/Zero/nix-config"
    # git remote set-url origin git@github.com:Prometheus7435/SCE-N.git
    git remote set-url origin "git@github.com:$GIT_REPO"
    popd

    mkdir -p "/mnt/home/${TARGET_USER}/.local/state/nix/profiles"

    ## folders used in my emacs config
    mkdir -p "/mnt/home/${TARGET_USER}/.config/emacs/{backups,emacs_autosave}"
fi
