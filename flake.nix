{
  description = "My NixOS configuration";

  inputs = {
    # NixOS packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flatpak management
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # CachyOS kernel
    nix-cachyos-kernel.url =
      "github:xddxdd/nix-cachyos-kernel";

    # Zen Browser
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Steam and game configuration
    steam-config-nix = {
      url = "github:different-name/steam-config-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };    

    # Noctalia
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # Umbriel
    umbriel.url = "github:noctalia-dev/umbriel";

    # Vice
    vice.url = "github:splitshotz/Vice";

    # Nixgram
    nixgram = {
      url = "github:Moonwuzy/Nixgram";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Nix Gaming
    nix-gaming = {
    url = "github:fufexan/nix-gaming";
    };

    # Ski
    ski = {
      url = "github:ilyamiro/Ski";
      flake = false;
    };
   
    # Rust overlay
    rust-overlay = {
    url = "github:oxalica/rust-overlay";
    };

    # yapfast
    yapfast = {
      url = "github:yapfast/yapfast";
    };

    # Steam Deck integration
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      nix-flatpak,
      nix-cachyos-kernel,
      vice,
      ...
    }:

    let
      # Shared Config
      commonModules = [
        (inputs.ski + "/nix/module.nix")
        home-manager.nixosModules.home-manager
        inputs.steam-config-nix.nixosModules.default

        {
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };

          # Noctalia Cachix
          nix.settings = {
            extra-substituters = [
              "https://noctalia.cachix.org"
            ];

            extra-trusted-public-keys = [
              "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
            ];
          };

          # Overlays
          nixpkgs.overlays = [
            nix-cachyos-kernel.overlays.pinned
          ];

          # Ski file manager
          programs.ski = {
            enable = true;
            defaultFileManager = true;
            filePicker = true;
          };
        }
      ];
    in
    {
      nixosConfigurations = {
        # Laptop: yaoilover
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = [
            vice.nixosModules.default
            ./hosts/laptop/configuration.nix
          ] ++ commonModules;
        };

        # Desktop: mafuyu
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

          modules = [
            vice.nixosModules.default
            ./hosts/desktop/configuration.nix
          ] ++ commonModules;
        };
	
        # Steam Deck
        steamdeck = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit inputs;
          };

	  modules = [
	  inputs.jovian.nixosModules.default
          home-manager.nixosModules.home-manager
          ./hosts/steamdeck/configuration.nix
          {
          home-manager.extraSpecialArgs = {
          inherit inputs;
            };
          }
        ];
       };
       
      };
    };
}
