
{ inputs, lib, pkgs, ... }:

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

    # Laptop-specific modules
    ../../modules/laptop/asus.nix
    ../../modules/laptop/graphics.nix
    ../../modules/laptop/power.nix

    # Shared desktop applications
    inputs.umbriel.nixosModules.default
  ];

  networking.hostName = "yaoilover";

  # Umbriel
  programs.umbriel.enable = true;

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

    # Laptop-specific keybindings
    xdg.configFile."sway/laptop.conf".text = ''
      bindsym XF86AudioMute exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindsym XF86AudioLowerVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindsym XF86AudioRaiseVolume exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ --limit 1.0

      bindsym XF86MonBrightnessDown exec brightnessctl -d intel_backlight set 5%-
      bindsym XF86MonBrightnessUp exec brightnessctl -d intel_backlight set 5%+

      bindsym XF86KbdBrightnessDown exec asusctl leds prev
      bindsym XF86KbdBrightnessUp exec asusctl leds next
      bindsym XF86Launch1 exec asusctl profile next
    '';

    # Laptop-specific Waybar layout
    xdg.configFile."waybar/config".source =
      ../../home/moonwuzy/.config/waybar/laptop-config;

    # Shared desktop styling
    xdg.configFile."waybar/style.css".source =
      lib.mkForce ../../home/moonwuzy/.config/waybar/desktop-style.css;

    xdg.configFile."wofi/style.css".source =
      lib.mkForce ../../home/moonwuzy/.config/wofi/desktop-style.css;

    xdg.configFile."kitty/kitty.conf".source =
      lib.mkForce ../../home/moonwuzy/.config/kitty/kitty.conf;
  };

  fileSystems."/mnt/holiday" = {
    device = "/dev/disk/by-uuid/fd8e2d9b-0c7c-43e8-b673-24bcd9aa859b";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
