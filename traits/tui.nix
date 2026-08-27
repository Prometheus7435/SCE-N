{ config, inputs, lib, pkgs, ... }:

{
  imports = [

  ];

  environment.systemPackages = [
    # pkgs.jellyfin-tui
    # pkgs.lynx
    # pkgs.meli
    # pkgs.neomutt
    # pkgs.steam-tui
    # pkgs.steamcmd
    # pkgs.tmuxPlugins.resurrect
    # pkgs.ueberzugpp
    # pkgs.ytui-music
    pkgs.himalaya
    pkgs.lf
    pkgs.ttyper
    pkgs.wiki-tui
    pkgs.ytfzf
  ];
}
