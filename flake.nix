
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

    # spotatui
    spotatui.url = "github:LargeModGames/spotatui";

    # Serpantinum
    serpantinum.url = "github:ilyamiro/serpantinum";

    # Noctalia
    noctalia.url = "github:noctalia-dev/noctalia/cachix";

    # Umbriel
    umbriel.url = "github:noctalia-dev/umbriel";

    # SilentSDDM
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Vice
    vice.url = "github:splitshotz/Vice";

    # Nixgram
    nixgram = {
      url = "github:Moonwuzy/Nixgram";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Millennium
    millennium.url =
      "github:SteamClientHomebrew/Millennium?dir=packages/nix";

    # Ski
    ski = {
      url = "github:ilyamiro/Ski";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      home-manager,
      proton-cachyos,
      nix-flatpak,
      nix-cachyos-kernel,
      vice,
      ...
    }:
    let
      # Shared Steam compatibility packages for both machines
      steamCompatPackages =
        let
          cachy = proton-cachyos.packages.x86_64-linux.default;
          ge = inputs.proton-ge.packages.x86_64-linux.default;

          cachyNamed = package:
            let
              display =
                "Proton-CachyOS ${
                  builtins.replaceStrings
                    [ "cachyos-" "-slr" ]
                    [ "" "" ]
                    package.version
                } (Steam Linux Runtime)";
            in
            package.overrideAttrs (old: {
              inherit display;
              passthru = (old.passthru or { }) // {
                inherit display;
              };
            });

          geNamed = package:
            let
              display =
                "GE-Proton ${
                  builtins.replaceStrings
                    [ "GE-Proton" ]
                    [ "" ]
                    package.version
                } (Steam Linux Runtime)";
            in
            package.overrideAttrs (old: {
              inherit display;
              passthru = (old.passthru or { }) // {
                inherit display;
              };
            });
        in
        [
          # Proton-CachyOS
          (cachyNamed cachy)
          (cachyNamed cachy.v10)

          # Proton-GE
          (geNamed ge)
          (geNamed ge.v9)
          (geNamed ge.v10)
        ];

      # Shared configuration for both machines
      commonModules = [
        (inputs.ski + "/nix/module.nix")
        home-manager.nixosModules.home-manager
        inputs.steam-config-nix.nixosModules.default
        inputs.silentSDDM.nixosModules.default

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
            inputs.millennium.overlays.default
          ];

          # Steam compatibility tools
          programs.steam.extraCompatPackages =
            steamCompatPackages;

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
            serpantinum = inputs.serpantinum;
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
            serpantinum = inputs.serpantinum;
          };

          modules = [
            vice.nixosModules.default
            ./hosts/desktop/configuration.nix
          ] ++ commonModules;
        };
      };
    };
}

