# Desktop NVIDIA/graphics settings moved from modules/nvidia.nix.
{ config, lib, pkgs, ... }:

{
  # NVIDIA kernel modules
  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_drm"
  ];

  # Graphics support (64-bit and 32-bit)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      # Intel integrated graphics / video acceleration
      intel-media-driver
      vpl-gpu-rt

      # NVIDIA video acceleration
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };
  
  # Electron Fixes
  #  environment.etc."xdg/electron-flags.conf".text = ''
  #  --enable-features=UseOzonePlatform,WaylandWindowDecorations,VaapiVideoDecodeLinuxGL,WaylandLinuxDrmSyncobj
  #  --ozone-platform-hint=auto
  #  --disable-gpu-shader-disk-cache
  #  '';

  # NVIDIA utilities and Wayland EGL support
  environment.systemPackages = with pkgs; [
    nv-codec-headers-12
    egl-wayland
  ];

  # Shared graphics environment variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";

  # Allow G-SYNC / VRR for supported OpenGL applications
  __GL_GSYNC_ALLOWED = "1";
  __GL_VRR_ALLOWED = "1";

  # NVIDIA video acceleration environment
    NVD_BACKEND = "direct";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  # X11 / Wayland NVIDIA driver
  services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    dynamicBoost.enable = false;
    powerManagement.enable = true;
    powerManagement.finegrained = false;

    open = true;
    nvidiaSettings = true;
    
    # Driver Version
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };
}

