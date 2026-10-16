{
  # Existing ASUS Zephyrus G16 backlight compatibility parameters.
  boot.kernelParams = [
    "i915.enable_dpcd_backlight=1"
    "nvidia.NVreg_EnableBacklightHandler=0"
    "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=0"
  ];
}
