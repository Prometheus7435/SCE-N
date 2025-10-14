{ config, inputs, lib, modulesPath, outputs, pkgs, desktop, hostname, stateVersion, username, ...}: {
  # - https://nixos.wiki/wiki/Nix_Language:_Tips_%26_Tricks#Coercing_a_relative_path_with_interpolated_variables_to_an_absolute_path_.28for_imports.29
  imports = [
    inputs.disko.nixosModules.disko
    (./. + "/${hostname}/default.nix")
    (./. + "/${hostname}/disks.nix")
    (modulesPath + "/installer/scan/not-detected.nix")

    ../users/${username}.nix # importing user settings from main flake
  ]
  # Only include desktop components if one is supplied.
  ++ lib.optional (builtins.isString desktop) ../traits/desktop;

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    gc = {
      automatic = true;
      options = "--delete-older-than 14d";
    };

    optimise.automatic = true;

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  system = {
    stateVersion = stateVersion;
    # autoUpgrade = {
    #   enable = true;
    #   allowReboot = false;
    #   flake = "${HOME}/Zero/nix-config" #inputs.self.outPath;
    #   flags = [
    #     "-L" # print build logs
    #   ];
    # };
  };

  boot = {
    kernelParams = [ ];
    extraModulePackages = with config.boot.kernelPackages; [
      acpi_call
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.configurationLimit = 10;
      systemd-boot.enable = true;
      systemd-boot.memtest86.enable = true;
      timeout = 10;
    };

    # initrd = {
    #   availableKernelModules = [
    #     "ahci"
    #     "ehci_pci"
    #     "mpt3sas"
    #     "nvme"
    #     "rtsx_pci_sdmmc"
    #     "usb_storage"
    #     "usbhid"
    #     "virtio_balloon"
    #     "virtio_blk"
    #     "virtio_pci"
    #     "virtio_ring"
    #     "xhci_pci"
    #   ];
    #   kernelModules = [

    #   ];
    };
# };

  hardware = {
    opengl = {
      enable = true;
      # driSupport = true;
      # driSupport32Bit = true;
    };

    bluetooth.enable = true;
    bluetooth.settings = {
    };
  };

  services = {
    auto-cpufreq.enable = true;

    fwupd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    binutils
    curl
    killall
    libgccjit
    man-pages
    pciutils
    rar
    rsync
    unzip
    unrar
    usbutils
    wget
    yt-dlp
  ];

  programs = {
    dconf.enable = true;
  };

  security.rtkit.enable = true;
}
