{ config, desktop, lib, pkgs, username, ...}:
let
  ifExists = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
   # Only include desktop components if one is supplied.
  imports = [
    # ./packages-console.nix
    # ../../services/nfs/client.nix
  ];
  # ++ lib.optional (builtins.isString desktop) ./packages-desktop.nix;

  users.users.${username} = {
    description = "Zach";
    extraGroups = [
        "audio"
        "dialout"
        "disk"
        "input"
        "network"
        "networkmanager"
        "systemd-journal"
        "users"
        "video"
        "wheel"
        "uucp"    # Used by some serial drivers/distros
      ]
      ++ ifExists [
        "docker"
        "podman"
        "libvirtd"
      ];
    # mkpasswd -m sha-512
    hashedPassword = "$6$RXjSt1BIOO1FjF7T$PFQb9p3fSICeDKYSRGaK9ibnO2JKg6aklwnjUSXAI8oVzfhr5IJLczhmGPbL4KuxhCw5II2uToio/er7QMgN11";
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp521 AAAAE2VjZHNhLXNoYTItbmlzdHA1MjEAAAAIbmlzdHA1MjEAAACFBAFYfJZwjC4Xdiwopc86qil1WqlLKIEyqhITphQ6ACinR/Bf15RPElPyNVkvv2GiAVhv7mmoQifZWdf0+NlxNNDpfwDT16YDmMCxB01JfrEq21Ml3P4zPAxZHoLmffc7ARKHjD8XYyibWG5Bu0AjzSfq4IDnRBEBx4JY4PAm4lSyKAfFmg== zach@phoenix"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOFJ0JftYliH/rZWkx2YLWx69pFGmSJdUNKaeTqaO//2 zach@phoenix"
    ];
    packages = [ pkgs.home-manager ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  services.udev.extraRules = ''
    # CP210x USB to UART Bridge (Common on Official DevKits)
    SUBSYSTEM=="tty", ATTRS{idVendor}=="10c4", ATTRS{idProduct}=="ea60", MODE="0666", GROUP="dialout"

    # CH340/CH341 USB to UART (Common on cheap clones)
    SUBSYSTEM=="tty", ATTRS{idVendor}=="1a86", ATTRS{idProduct}=="7523", MODE="0666", GROUP="dialout"

    # FTDI USB to UART
    SUBSYSTEM=="tty", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666", GROUP="dialout"

    # Generic fallback for any USB serial device
    KERNEL=="ttyUSB*", MODE="0666", GROUP="dialout"
    KERNEL=="ttyACM*", MODE="0666", GROUP="dialout"
  '';
}
