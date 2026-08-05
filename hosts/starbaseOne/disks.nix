# straight copy from archer. StarbaseOne has a 16GB Optane drive which I'm planning to use btrfs on
# device = "/dev/nvme0n1";
# { config, inputs, username, ...}:

let
  btrfsopt = [
    "compress=zstd"
    "noatime"
    "ssd"
    "space_cache=v2"
    "user_subvol_rm_allowed"
    # "autodefrag"
    # "discard=async"
  ];
in
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "1024M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = btrfsopt;
                  };
                  "/user" = {
                    mountpoint = "/home/decker";
                    mountOptions = btrfsopt;
                  };
                  "/persist" = {
                    mountpoint = "/persist";
                    mountOptions = btrfsopt;
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = btrfsopt;
                  };
                  "/swap" = {
                    mountpoint = "/.swapvol";
                    swap.swapfile.size = "16G"; # for hibernate, "should" be equal to RAM
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
