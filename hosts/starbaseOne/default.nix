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



# **BLUF:** Use a VLAN-filtering Linux bridge with the second NIC as an access port for the VM VLAN, but assign **no IP address, DHCP client, route, or VLAN membership to the host-side bridge interface**. Attach VM TAP interfaces to that bridge and place them in the same VLAN.

# This prevents normal host networking from using the VM-facing network. It does **not** prevent a privileged host administrator from later reconfiguring or packet-capturing the NIC; the host ultimately controls its own hardware.

# ```nix
# # /etc/nixos/configuration.nix
# { config, pkgs, ... }:

# {
#   # Use systemd-networkd rather than the legacy networking backend.
#   networking.useNetworkd = true;
#   systemd.network.enable = true;

#   # Replace these with the actual names from: ip link
#   #
#   # enp1s0 = host/uplink Ethernet port
#   # enp2s0 = VM-only Ethernet port
#   #
#   # VLAN 100 is the VM network VLAN.

#   systemd.network = {
#     # Host-facing Ethernet interface: normal host network connectivity.
#     networks."10-host-uplink" = {
#       matchConfig.Name = "enp1s0";

#       networkConfig = {
#         DHCP = "yes";
#         IPv6AcceptRA = true;
#       };

#       linkConfig.RequiredForOnline = "routable";
#     };

#     # Create a VLAN-aware bridge used only for VM forwarding.
#     netdevs."20-vmbr0" = {
#       netdevConfig = {
#         Name = "vmbr0";
#         Kind = "bridge";
#       };

#       bridgeConfig = {
#         VLANFiltering = true;
#       };
#     };

#     # Physical VM-only Ethernet port.
#     #
#     # This makes enp2s0 an *untagged access port* in VLAN 100.
#     # If the connected switch/device expects tagged VLAN frames instead,
#     # remove PVID and EgressUntagged and configure it as a trunk instead.
#     networks."30-vm-physical-port" = {
#       matchConfig.Name = "enp2s0";

#       networkConfig = {
#         Bridge = "vmbr0";
#         LinkLocalAddressing = "no";
#         LLDP = false;
#         EmitLLDP = false;
#       };

#       bridgeVLANs = [
#         {
#           bridgeVLANConfig = {
#             VLAN = 100;
#             PVID = true;
#             EgressUntagged = true;
#           };
#         }
#       ];

#       linkConfig.RequiredForOnline = "enslaved";
#     };

#     # Intentionally do NOT configure DHCP, addresses, gateways, DNS,
#     # or VLAN membership on vmbr0. The host therefore has no Layer-3
#     # presence on the VM VLAN.
#     networks."40-vm-bridge" = {
#       matchConfig.Name = "vmbr0";

#       networkConfig = {
#         LinkLocalAddressing = "no";
#         LLDP = false;
#         EmitLLDP = false;
#         ConfigureWithoutCarrier = true;
#       };

#       linkConfig.RequiredForOnline = "no";
#     };
#   };

#   # Optional: enable libvirt if it is your VM manager.
#   virtualisation.libvirtd.enable = true;
# }
# ```

# For each VM, attach its virtual NIC to `vmbr0` and configure that VM interface as VLAN 100. In libvirt domain XML, the relevant interface structure is:

# ```xml
# <interface type='bridge'>
#   <source bridge='vmbr0'/>
#   <vlan>
#     <tag id='100'/>
#   </vlan>
#   <model type='virtio'/>
# </interface>
# ```

# ### Result

# | Interface | Intended use | Host IP configuration |
# |---|---|---|
# | `enp1s0` | Host uplink / management / normal traffic | DHCP or static IP |
# | `enp2s0` | Physical VM-only port, access VLAN 100 | None |
# | `vmbr0` | Layer-2 VM forwarding bridge | None |
# | VM TAP interfaces | VM attachment to VLAN 100 | VM-controlled |

# ### Important implementation notes

# - Do **not** add `vmbr0` to `networking.interfaces`, NetworkManager, or a DHCP/static-address configuration.
# - Do **not** configure `enp2s0.100` on the host; that would explicitly give the host an interface on the VM VLAN.
# - The configuration shown treats the second Ethernet port as an **untagged VLAN 100 access port**. If it connects to a switch trunk, its VLAN configuration must be adjusted to preserve tags.
# - The host will still administratively own `enp2s0` and `vmbr0`; this is configuration isolation, not a hardware-enforced separation. For stronger isolation, use separate hardware, an SR-IOV virtual function passed directly to a VM, or a dedicated external switch/firewall boundary.


}
