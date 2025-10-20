{ inputs, pkgs, username, ... }: {
  imports = [

  ];

  services = {
    accounts-daemon.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
      # xkb.options = "grp:win_space_toggle";

      desktopManager = {
        plasma5 = {
          enable = true;
        };
      };

      displayManager = {
        lightdm.enable = true;  # lets me autoLogin after decrypting zfs
        defaultSession = "plasmawayland";
        autoLogin = {
          enable = true;
          user = "${username}";
        };
      };
    };

  };

  programs = {
    dconf = {
      enable = true;
    };
    kdeconnect = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    kdePackages.applet-window-buttons6
    kdePackages.baloo
    kdePackages.discover
    kdePackages.dragon
    kdePackages.filelight
    kdePackages.kalk
    kdePackages.kdeconnect-kde
    kdePackages.kdecoration
    kdePackages.kdeplasma-addons
    kdePackages.kfind
    kdePackages.okular
    kdePackages.plasma-integration
    kdePackages.plasma-pa
    kdePackages.qtstyleplugin-kvantum
    kdePackages.xdg-desktop-portal-kde
    kdePackages.yakuake
    kdePackages.kate
  ];
}
