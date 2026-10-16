{ ... }:

{
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    extraConfig.pipewire-pulse = {
      "volume-limit" = {
        "pulse.min-volume" = "0x0";
        "pulse.max-volume" = "0x10000";
      };
    };
  };

  # PipeWire xrun / crackling fix is applied through Home Manager in services.nix.
}
