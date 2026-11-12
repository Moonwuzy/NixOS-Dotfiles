
{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./packages.nix
    inputs.umbriel.nixosModules.default
  ];

  # Hostname
  networking.hostName = "steamdeck";

  # Allow Steam and other proprietary packages
  nixpkgs.config.allowUnfree = true;

  # CachyOS Handheld kernel
  nixpkgs.overlays = [
    inputs.nix-cachyos-kernel.overlays.pinned
  ];

  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-deckify;

  # Steam Deck LCD graphics (AMD APU)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "amdgpu" ];

  # Umbriel desktop session
  programs.umbriel.enable = true;

  # Jovian-NixOS
  jovian.devices.steamdeck.enable = true;
  jovian.hardware.has.amd.gpu = true;
  jovian.steamos.useSteamOSConfig = true;

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "moonwuzy";
    desktopSession = "umbriel";
  };

  # User account
  users.users.moonwuzy = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
      "input"
    ];
  };

  networking.networkmanager.enable = true;

  # Noctalia through Home Manager
  home-manager.users.moonwuzy = { inputs, ... }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    home.username = "moonwuzy";
    home.homeDirectory = "/home/moonwuzy";
    home.stateVersion = "26.11";

    programs.noctalia = {
      enable = true;
      systemd.enable = true;

      settings = {
        theme = {
          mode = "dark";
          source = "builtin";
          builtin = "Catppuccin";
        };

        wallpaper = {
          enabled = true;
          default.path =
            "/home/moonwuzy/Pictures/Wallpapers/violet.jpg";
        };
      };
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  # NixOS state version
  system.stateVersion = "26.11";
}

