(config, inputs, lib, pkgs, username,...);
{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    extraOptions = {
      overrideFolders = false;
      overrideDevices = false;
      user = home-presets.username;
      dataDir = home-presets.homeDirectory;
    };
    # settings = {
    #   gui = {
    #     user = "${username}";
    #     password = "mypassword";
    #   };
    #   devices = {
    #     "device1" = { id = "DEVICE-ID-GOES-HERE"; };
    #     "device2" = { id = "DEVICE-ID-GOES-HERE"; };
    #   };
    #   folders = {
    #     "org" = {
    #       path = "/home/${username}/Documents";
    #       devices = [ "device1" "device2" ];
    #     };
    #     "Example" = {
    #       path = "/home/${username}/Example";
    #       devices = [ "device1" ];
    #       ignorePerms = false; # Enable file permission syncing
    #     };
    #   };
    # };
  };


}
