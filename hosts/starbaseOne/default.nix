# straight copy from my other nixos config
{ config, inputs, lib, pkgs, username, modulesPath, hostname, hostid, ... }:
{
  imports = [
    # inputs.nixos-hardware.nixosModules.common-gpu-amd
#    inputs.nixos-hardware.nixosModules.common-gpu-nvidia
    inputs.nixos-hardware.nixosModules.common-pc
    inputs.nixos-hardware.nixosModules.common-pc-ssd
    inputs.nixos-hardware.nixosModules.supermicro # mobo is supermicro
    ../../traits/default.nix
    # ../_mixins/hardware/systemd-boot.nix

    # ../_mixins/services/nfs/server.nix

    # ../_mixins/boxes/virtualization.nix

    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    supportedFilesystems = [ "zfs" "btrfs"];
    zfs = {
      extraPools = [ "vmpool" "alpha"];
      requestEncryptionCredentials = true;
    };

    kernelPackages = pkgs.linuxPackages;
    kernelParams = [
      "mitigations=off"
    ];

    initrd = {
      kernelModules = [
        "amdgpu"
      ];
    };
  };

  swapDevices = [ ];

  services = {
    zfs.autoScrub.enable = true;
    fstrim.enable = true;
  };

  networking = {
    hostName = hostname;
    hostId = hostid;
    useDHCP = lib.mkDefault true;
    firewall = {
      enable = true;
    };
    # TODO: figure out a better way of passing networking to the VM
    # macvlans = {
    #   iot = {
    #     interface = "enp132s0f0";
    #     mode = "bridge";
    #   };
    # };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  powerManagement.enable = true;
  environment.systemPackages = with pkgs; [
    cpufrequtils  # allows turboing on cpu cores
  ];

  hardware = {
    xone.enable = true;
  };
}
