{ config, inputs, lib, pkgs, username, modulesPath, hostname, hostid, ... }:
{
  imports = [];


  # NFSv3 config
  services.nfs.server = {
    enable = true;
    # fixed rpc.statd port; for firewall
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    extraNfsdConfig = '''';
    exports = ''
    /home    192.0.2.0/24(insecure,rw,sync,no_subtree_check)
  '';
  };
  networking.firewall = {
    enable = true;
      # for NFSv3; view with `rpcinfo -p`
    allowedTCPPorts = [ 111  2049 4000 4001 4002 20048 ];
    allowedUDPPorts = [ 111 2049 4000 4001  4002 20048 ];
  };
  # networking.firewall.allowedTCPPorts = [ 2049 ];

}
