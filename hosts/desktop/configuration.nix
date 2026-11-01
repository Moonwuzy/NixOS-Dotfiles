{ lib, inputs, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core/boot.nix
    ../../modules/core/networking.nix
    ../../modules/core/nix.nix
    ../../modules/core/users.nix
    ../../modules/core/audio.nix
    ../../modules/core/services.nix
    ../../modules/core/niri.nix
    ../../modules/core/gaming.nix
    ../../modules/core/packages.nix
    ../../modules/desktop/zram.nix
    ../../modules/desktop/swap.nix
    ../../modules/desktop/graphics.nix
    ../../modules/core/virtualization.nix

    inputs.umbriel.nixosModules.default
  ];

  programs.umbriel.enable = true;

  networking.hostName = "mafuyu";

  services.hardware.openrgb = {
    enable = true;
    motherboard = "amd";
  };

  networking.firewall.trustedInterfaces = [ "eno1" ];

  networking.extraHosts = ''
    0.0.0.0 test-s1.battleye.com
    0.0.0.0 paradiseenhanced-s1.battleye.com
  '';

  users.users.moonwuzy.extraGroups = [
    "video"
    "render"
    "input"
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  time.hardwareClockInLocalTime = false;

  fileSystems."/mnt/violet" = {
    device = "/dev/disk/by-uuid/4ca3614a-2f66-4983-a33a-d12d58e99a64";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/08BEF504BEF4EAD8";
    fsType = "ntfs3";
    options = [
      "nofail"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

  home-manager.users.moonwuzy = { inputs, ... }: {
    imports = [
      inputs.serpantinum.homeManagerModules.default
      inputs.noctalia.homeModules.default
    ];

    # Serpantinum
    systemd.user.services.serpantinum.Service.Environment =
      "QML2_IMPORT_PATH=${pkgs.qt6.qtdeclarative}/lib/qt-6/qml";

    programs.serpantinum = {
      enable = true;
      systemd.enable = false;

      settings = {
        wallpaperDir = "/home/moonwuzy/Pictures/Wallpapers";

        general = {
          language = "en";
          weatherUnit = "metric";
          weatherInterval = 30;
        };

        bar = {
          position = "top";
          style = "solid";
          width = 40;
          workspaceCount = 10;

          modules = {
            left = [ "workspaces" ];
            center = [ "time" ];
            right = [ "tray" [ "kb" "wifi" "bt" "vol" "bat" ] ];
          };
        };

        theme = {
          fontFamily = "Adwaita Mono";
          borderRadius = 12;
          matugen = true;
        };

        notifications = {
          dnd = false;
          position = "top right";
          sound = true;
        };
      };
    };

    # Noctalia
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
          default.path = "/home/moonwuzy/Pictures/Wallpapers/violet.jpg";
        };
      };
    };

    home.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    xdg.configFile = {
      # Niri
      "niri/config.kdl".source =
        ../../home/moonwuzy/.config/niri/config.kdl;

      "niri/cursor.kdl".source =
        ../../home/moonwuzy/.config/niri/cursor.kdl;

      "niri/tilemod_config.toml".source =
        ../../home/moonwuzy/.config/niri/tilemod_config.toml;

      "niri/scripts".source =
        ../../home/moonwuzy/.config/niri/scripts;

      # Umbriel
      "umbriel/config.toml".source =
        ../../home/moonwuzy/.config/umbriel/config.toml;

      "umbriel/outputs.toml".source =
        ../../home/moonwuzy/.config/umbriel/outputs.toml;

      "umbriel/cursor.toml".source =
        ../../home/moonwuzy/.config/umbriel/cursor.toml;

      # Desktop-specific settings
      "sway/desktop.conf".text = ''
        # Cursor
        seat * xcursor_theme Adwaita 20
      '';

      "waybar/config".source =
        ../../home/moonwuzy/.config/waybar/desktop-config;

      "waybar/style.css".source =
        lib.mkForce ../../home/moonwuzy/.config/waybar/desktop-style.css;

      "wofi/style.css".source =
        lib.mkForce ../../home/moonwuzy/.config/wofi/desktop-style.css;

      "kitty/kitty.conf".source =
        lib.mkForce ../../home/moonwuzy/.config/kitty/kitty.conf;
    };
  };
}
