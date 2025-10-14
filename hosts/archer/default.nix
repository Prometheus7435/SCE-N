# ThinkPad X1 Carbon
# CPU: Intel
# GPU:
# RAM: 16GB
# NVME:

{ config, inputs, lib, pkgs, username, modulesPath, desktop, ... }:
let
  # pkgs = import <nixpkgs> {
  #   overlays = [
  #     (self: super: {
  #       stdenv = super.impureUseNativeOptimizations super.stdenv;
  #     })
  #   ];
  # };
in
{
  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-9th-gen
    ./disks.nix
    # ../default.nix

    # ../traits/desktop/${desktop}.nix
    # ../_mixins/services/nfs/client.nix
    ../traits/mobile.nix

    # ../_mixins/services/pipewire.nix
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
    # zfs.requestEncryptionCredentials = true;

    kernelPackages = pkgs.linuxPackages_zen;
    # kernelParams = [ "nohibernate"];

    # extraModulePackages = with config.boot.kernelPackages; [
    #   # acpi_call
    # ];

    # initrd = {
    #   availableKernelModules = [

    #   ];
    #   kernelModules = [

    #   ];
    # };
  };

  swapDevices = [ ];

  nix.settings.system-features = [ "big-parallel" ];

  nixpkgs.hostPlatform = {
    system = "x86_64-linux"
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  environment.systemPackages = with pkgs; [

  ];

  hardware = {
    sensor = {
      # automatic screen orientation
      iio = {
        enable = true;
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services = {
    # xserver.libinput.enable = true;
    powerManagement.enable = true;
    # tlp = {
    #   settings = {
    #     START_CHARGE_THRESH_BAT0 = "75";
    #     STOP_CHARGE_THRESH_BAT0 = "95";
    #   };
    # };

    # fingerprint reader
    # fprintd.enable = true;

  };
  security = {
    pam.services.login.fprintAuth = true;
    pam.services.xscreensaver.fprintAuth = true;
  };

  networking = {
    networkmanager = {
      enable = true;  # Easiest to use and most distros use this by default.
    };
    hostName = hostname;
    hostId = hostid;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = false;
        # allowedTCPPorts = [ 80 443 ];
        # allowedUDPPortRanges = [
        #   { from = 4000; to = 4007; }
        #   { from = 8000; to = 8010; }
      # ];
    };
  };
}
