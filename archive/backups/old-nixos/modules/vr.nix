# modules/vr.nix
{ config, lib, pkgs, ... }:

{

services.avahi = {
  enable = true;
  openFirewall = true;
  publish.enable = true;
  publish.userServices = true;
};

  # Quest 3 wireless PCVR through WiVRn.
  services.wivrn = {
    enable = true;

    # Allow Quest 3 discovery and streaming through the firewall.
    openFirewall = true;

    # Start the WiVRn server automatically at boot.
    autoStart = true;

    # Enable NVIDIA GPU encoding support for the RTX 3070.
    package = pkgs.wivrn.override {
      cudaSupport = true;
    };

    # Allow Steam to discover OpenXR runtimes.
    steam = {
      enable = true;
      importOXRRuntimes = true;
    };
  };

  # SteamVR Lighthouse tracking support for Vive 3.0 trackers.
  # Keep these settings if they are not already defined elsewhere.
  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };
}
