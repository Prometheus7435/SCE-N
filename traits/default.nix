{ config, desktop, inputs, lib, outputs, pkgs, username, stateVersion, emacs-overlay, ... }:
{
  imports = [
    # ./console
    # ./emacs
    # ./fish.nix
    # ./git.nix
    ./locale.nix
    # ./nano.nix
    ./openssh.nix
    ./tailscale.nix
    # ./tmux.nix
  ];

  environment.systemPackages = with pkgs; [
    acpi # used in tmux
    binutils
    cpufrequtils  # allows turboing on cpu cores
    curl
    file
    git
    gpart
    home-manager
    htop
    killall
    kitty
    libgccjit
    man-pages
    nano
    pciutils
    rar
    rsync
    unzip
    unrar
    usbutils
    wget
    yt-dlp

    # emacs requirements
    # texlive.# commentmbined.scheme-full
    # nixfmt-classic
    ispell
    aspell
    black
    python313Packages.jedi
  ];

  programs = {
    dconf.enable = true;
  };

  security.rtkit.enable = true;


}
