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
    settings = {
    #   gui = {
    #     user = "${username}";
    #     password = "mypassword";
      };
      devices = {
        "pixel9a" = { id = "7WEGZC4-LFFE4BI-ZFIRNHM-3OPIQ7A-72O6ZKO-AGGHBP4-DTTIVBI-RC2XEQL"; };
#        "device2" = { id = "DEVICE-ID-GOES-HERE"; };
      };
      folders = {
        "org" = {
          path = "/home/${username}/sync";
          devices = [ "pixel9a" ];
        };
    #     "Example" = {
    #       path = "/home/${username}/Example";
    #       devices = [ "device1" "device2" ];
    #       ignorePerms = false; # Enable file permission syncing
    #     };
    #   };
    };
  };


}
