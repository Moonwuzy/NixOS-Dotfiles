{
  description = "My NixOS configuration";

  inputs = {
    # NixOS packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Proton-CachyOS
    proton-cachyos = {
      url = "github:Daaboulex/proton-cachyos-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Proton-GE
    proton-ge = {
      url = "github:Daaboulex/proton-ge-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flatpak management
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    # CachyOS kernel
    nix-cachyos-kernel.url =
      "github:xddxdd/nix-cachyos-kernel/release";

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
     
    # qylock
    qylock.url = "github:Darkkal44/qylock";
   
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      proton-cachyos,
      nix-flatpak,
      nix-cachyos-kernel,
      qylock,
      ...
    }:
    let
      # Shared Steam compatibility packages for both machines
      steamCompatPackages =
        let
          cachy = proton-cachyos.packages.x86_64-linux;
          ge = inputs.proton-ge.packages.x86_64-linux;

          cachyNamed = package:
            package.override {
              steamDisplayName =
                "Proton-CachyOS ${
                  builtins.replaceStrings
                    [ "cachyos-" "-slr" ]
                    [ "" "" ]
                    package.version
                } (Steam Linux Runtime)";
            };

          geNamed = package:
            package.override {
              steamDisplayName =
                "GE-Proton ${
                  builtins.replaceStrings
                    [ "GE-Proton" ]
                    [ "" ]
                    package.version
                } (Steam Linux Runtime)";
            };
        in
        [
          # Proton-CachyOS
          (cachyNamed cachy.default)
          (cachyNamed cachy.proton-cachyos.v10)

          # Proton-GE
          (geNamed ge.default)
          (geNamed ge.v9)
          (geNamed ge.v10)
        ];

      # Shared configuration for both machines
      commonModules = [
        home-manager.nixosModules.home-manager
        inputs.steam-config-nix.nixosModules.default

        {
          nixpkgs.overlays = [
            nix-cachyos-kernel.overlays.pinned
          ];

          programs.steam.extraCompatPackages =
            steamCompatPackages;
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
            qylock.nixosModules.default
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
            qylock.nixosModules.default
            ./hosts/desktop/configuration.nix
          ] ++ commonModules;
        };
      };
    };
}
