{ ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core/boot.nix
    ../../modules/core/networking.nix
    ../../modules/core/nix.nix
    ../../modules/core/users.nix
    ../../modules/core/audio.nix
    ../../modules/core/services.nix
    ../../modules/core/sway.nix
    ../../modules/core/gaming.nix
    ../../modules/core/packages.nix
    ../../modules/laptop/asus.nix
    ../../modules/laptop/graphics.nix
    ../../modules/laptop/power.nix
  ];

  networking.hostName = "yaoilover";

  home-manager.users.moonwuzy = {
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

    xdg.configFile."waybar/config".source =
      ../../home/moonwuzy/.config/waybar/laptop-config;
  };

  fileSystems."/mnt/holiday" = {
    device = "/dev/disk/by-uuid/fd8e2d9b-0c7c-43e8-b673-24bcd9aa859b";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
