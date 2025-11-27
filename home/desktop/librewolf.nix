{ home-manager, config, lib, pkgs, username, ... }:
{
  imports = [

  ];

#  home-manager.users.${username} = {
    programs.librewolf = {
       enable = true;
       # Enable WebGL, cookies and history
#       pkcs11Modules = true;
       settings = {
            "webgl.disabled" = false;
            "privacy.resistFingerprinting" = false;
            "privacy.clearOnShutdown.history" = false;
            "privacy.clearOnShutdown.cookies" = false;
            "network.cookie.lifetimePolicy" = 0;
	     };
       # ExtensionSettings = {
       #  "addon@darkreader.org" = {
       #    install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
       #    installation_mode = "force_installed";
       #  };
       # };
    };
#  };
}
