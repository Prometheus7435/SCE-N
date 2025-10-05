{ config, inputs, lib, pkgs, ... }:

{
  imports = [

  ];

  environment.systemPackages = [
    # pkgs.ytui-music
    # pkgs.ueberzugpp
    pkgs.ytfzf
    # pkgs.lynx
    # pkgs.tmuxPlugins.resurrect
    pkgs.wiki-tui
    pkgs.lf
    pkgs.ttyper
    # pkgs.jellyfin-tui
    # pkgs.meli
    # pkgs.neomutt
    # pkgs.himalaya
    # pkgs.steamcmd
    # pkgs.steam-tui
  ];
}
