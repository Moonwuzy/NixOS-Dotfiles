{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
  ];

  # Laptop hostname
  networking.hostName = "yaoilover";

  # ASUS-specific
  services.asusd.enable = true;

  systemd.services.asusd.serviceConfig.ConfigurationDirectory = "asusd";

  # G16 backlight fixes
  boot.kernelParams = [
    "i915.enable_dpcd_backlight=1"
    "nvidia.NVreg_EnableBacklightHandler=0"
    "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=0"
  ];
  
    # ASUS Zephyrus G16 Fn keys
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

  # NVIDIA + Intel hybrid graphics
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;

    powerManagement.enable = true;
    powerManagement.finegrained = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  # Laptop disk
  fileSystems."/mnt/holiday" = {
    device = "/dev/disk/by-uuid/fd8e2d9b-0c7c-43e8-b673-24bcd9aa859b";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}
