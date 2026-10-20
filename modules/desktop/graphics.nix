{ config, pkgs, ... }:

{
  # Graphics and 32-bit libraries for Steam and Proton
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    
    extraPackages = with pkgs; [
      intel-media-driver
      nvidia-vaapi-driver
    ];
  };

  # NVIDIA driver
  hardware.nvidia = {
    modesetting.enable = true;

    # RTX 3070 supports NVIDIA's open kernel modules
    open = true;

    # Keep power management simple while troubleshooting
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    forceFullCompositionPipeline = true;

    nvidiaSettings = true;

    # Driver Branch
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  # NVIDIA VA-API configuration
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    NVD_BACKEND = "direct";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
