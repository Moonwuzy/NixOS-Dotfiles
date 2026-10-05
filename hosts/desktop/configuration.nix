{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
    ./hardware-configuration.nix
     ];

  # Desktop hostname
  networking.hostName = "mafuyu";

  # NVIDIA RTX 3070
  services.xserver.videoDrivers = [
    "nvidia"
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  home-manager.users.moonwuzy = {
    xdg.configFile."waybar/config".source =
      ../../home/moonwuzy/.config/waybar/desktop-config;
  };
}
