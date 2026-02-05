{ config, ... }:
{
  imports = [

  ];

  # User-specific installation (in ~/.config/nixpkgs/home.nix)
  home.packages = with pkgs; [
    kitty
  ];

  programs.kitty = lib.mkForce {
  enable = true;
  settings = {
    # confirm_os_window_close = 0;
    # dynamic_background_opacity = true;
    # enable_audio_bell = false;
    # mouse_hide_wait = "-1.0";
    # window_padding_width = 10;
    # background_opacity = "0.5";
    # background_blur = 5;
#    symbol_map = let
    mappings = [
      "ctrl-enter"
    ];
  #   in
  #     (builtins.concatStringsSep "," mappings) + " Symbols Nerd Font";
  # };
};
