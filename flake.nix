{
  description =
    "My NixOS config that's a (mostly) fresh start.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixos-hardware.url = "github:nixos/nixos-hardware";

    # hyprland.url = "github:hyprwm/Hyprland";
    # nix.settings = {
    #   substituters = ["https://hyprland.cachix.org"];
    #   trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    # };

    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  };

  outputs = {
    self,
      nixpkgs,
      home-manager,
      nixos-hardware,
      emacs-overlay,
      disko,
      ...
  }:
    let
      inherit (self) outputs;
      # forAllSystems = nixpkgs.lib.genAttrs [
      #   # "aarch64-linux"
      #   "x86_64-linux"
      # ];
      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      state_version = "25.11";
    in {
      nixosConfigurations = {
        archer = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            # inherit inputs outputs;
            desktop = "hyperland";
            hostid = "1a74db91"; # head -c 8 /etc/machine-id
            hostname = "archer";
            username = "shyfox";
          };
          stateVersion = state_version;
          modules = [
            ./hosts
            # ./users
            # nur.nixosModules.nur
          ];
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#your-username@your-hostname'
      homeConfigurations = {
        "shyfox@archer" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {
            # inherit inputs outputs;
            desktop = "hyperland";
            username = "shyfox";
            stateVersion = state_version;
          };
          modules = [
            ./home
                    ];
        };
      };
    };
}
