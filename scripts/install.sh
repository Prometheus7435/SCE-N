#!/usr/bin/env bash

## scripts/install.sh <hostname> <username>
## Ex. sh scripts/install.sh archer shyfox

set -euo pipefail

TARGET_HOST="${1:-archer}"
TARGET_USER="${2:-shyfox}"

GIT_REPO="Prometheus7435/SCE-N.git"
CONFIG_FOLDER=".SCE-N"

# diskpass=""

if [ ! -d "$HOME/${CONFIG_FOLDER}/.git" ]; then
  git clone "https://github.com/$GIT_REPO" "$HOME/${CONFIG_FOLDER}"
fi

# pushd "$HOME/.SCE-N"
pushd "$HOME/${CONFIG_FOLDER}"

if [ ! -e "hosts/${TARGET_HOST}/disks.nix" ]; then
  echo "ERROR! $(basename "${0}") could not find the required hosts/${TARGET_HOST}/disks.nix"
  exit 1
fi

echo "WARNING! The disks in ${TARGET_HOST} are about to get wiped"
echo "         NixOS will be re-installed"
echo "         This is a destructive operation"
echo
read -p "Are you sure? [y/N]" -n 1 -r

if [[ $REPLY =~ ^[Yy]$ ]]; then

    # create file with user entered password for disk encryption
    # echo
    # echo "enter disk password"
    # read diskpass
    # echo diskpass >> /tmp/secret.key
    # echo

    sudo true

    sudo nix --experimental-features "nix-command flakes" \
	 run github:nix-community/disko/latest \
	 -- \
	 --mode destroy,format,mount \
	 "hosts/${TARGET_HOST}/disks.nix"

    sudo nixos-install --no-root-password --flake ".#${TARGET_HOST}"

    # Rsync my nix-config to the target install
    # mkdir -p ~/.local/state/nix/profiles
    mkdir -p "/mnt/home/${TARGET_USER}/${CONFIG_FOLDER}"
    # rsync -a --delete "${PWD}/" "/mnt/home/${TARGET_USER}/Zero/nix-config/"

    # Rsync nix-config to the target install and set the remote origin to SSH.
    rsync -a --delete "$HOME/${CONFIG_FOLDER}/" "/mnt/home/$TARGET_USER/${CONFIG_FOLDER}/"
    pushd "/mnt/home/$TARGET_USER/${CONFIG_FOLDER}"
    # git remote set-url origin git@github.com:Prometheus7435/SCE-N.git
    git remote set-url origin "git@github.com:$GIT_REPO"
    popd

    mkdir -p "/mnt/home/${TARGET_USER}/.local/state/nix/profiles"

    ## folders used in my emacs config
    mkdir -p "/mnt/home/${TARGET_USER}/.config/emacs/{backups,emacs_autosave}"
fi
