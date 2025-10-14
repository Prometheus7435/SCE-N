{ pkgs, config, username, input, ...}:
{
  imports = [

  ];
  nix.settings = {
    substituters = [ "https://hyprland.cachix.org" ];
    trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
  };

  programs = {
    hyprlock.enable = true;
    hyprland = {
      enable = true;
      withUWSM = true; # recommended for most users
      xwayland.enable = true; # Xwayland can be disabled.
    };
    waybar.enable = true;
  };

  services = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "${username}";
      };
      defaultSession = "hyprland";
      sddm.wayland.enable = true;
    };

  };
  environment.systemPackages = with pkgs; [
    hyprcursor
    hypridle
    hyprland-qt-support # for hyprland-qt-support
    hyprlang
    hyprlock
    hyprpaper
    hyprpolkitagent
    hyprshot
    kitty
    libnotify
    mako
    mesa
    nwg-displays
    nwg-look
    pyprland
    qt5.qtwayland
    qt6.qtwayland
    swayidle
    swaylock-effects
    waybar
    waypaper
    wl-clipboard
    wlogout
    wofi
  ];
}
