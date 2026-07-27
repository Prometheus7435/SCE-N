{config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Yubikey
    yubikey-agent
    yubikey-manager
    yubikey-personalization
    libfido2
    pam_u2f
    gnupg
    pinentry-all

    opensc
    pcsclite
    pcsc-tools
  ];

}
