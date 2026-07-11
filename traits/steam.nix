{ config, lib, pkgs, ... }:

{
  imports = [

  ];
  # Allows the unfree bits that Steam requires. Here mostly as a just in case unfree isn't already engaged
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-unwrapped"
  ];

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;  # Open ports in the firewall for Steam Remote Play
    # dedicatedServer.openFirewall = true; # Open ports for Source Dedicated Server hosting
    # Other general flags if available can be set here.
    extraPackages = [
      pkgs.hidapi

    ];
  };

  # Allows games to temporarily set optimizations while you're playing
  programs.gamemode.enable = true;

  environment.systemPackages = [
    pkgs.steamcmd
    pkgs.steam-tui
  ];

  # Graphics setting to help prevent startup issues
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
