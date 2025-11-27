{ config, inputs, desktop, pkgs, ... }: {
  imports = [
    # ../services/nextcloud/client.nix
    (./. + "/${desktop}.nix")
  ];

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # (nerdfonts.override { fonts = [ "FiraCode" "UbuntuMono"]; })
      cooper-hewitt
      fira
      fira-code
      fira-code-symbols
      ibm-plex
      iosevka
      liberation_ttf
      # nerd-fonts.UbuntuMono
      # nerd-fonts._0xproto
      # nerd-fonts.droid-sans-mono
      # nerdfonts
      powerline-fonts
      source-code-pro
      spleen
      ubuntu-classic
      ucs-fonts
      work-sans
    ]
    ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  };

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox;
    };
  };

  services = {
    libinput.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  environment.systemPackages = [
    # pkgs.alacritty
    pkgs.vlc
    # pkgs.chromium
    # pkgs.libreoffice
    # pkgs.thunderbird
    # pkgs.calibre
    pkgs.vdhcoapp # to get it to work, you need to run path/to/net.downloadhelper.coapp install --user
  ];

  hardware = {
    # pulseaudio.enable = false;
  };
}
