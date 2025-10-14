{ config, nur, inputs, desktop, pkgs, ... }: {
  imports = [
    # ../services/nextcloud/client.nix
    (./. + "/${desktop}.nix")
  ];

  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      # (nerdfonts.override { fonts = [ "FiraCode" "UbuntuMono"]; })
      nerd-fonts.FiraCode
      nerd-fonts.UbuntuMono
      liberation_ttf
      work-sans
      source-code-pro
      fira-code
      fira-code-symbols
      fira
      nerdfonts
    ];
  };

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-wayland;
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
