{ config, pkgs, ... }:

{
  imports = [
    ../../modules/common.nix
     ];

  # Desktop hostname
  networking.hostName = "mafuyu";
  
  # Temporary root filesystem for dry-build testing.
  # This will be replaced by the real desktop hardware-configuration.nix.
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS";
    fsType = "ext4";
  };

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
