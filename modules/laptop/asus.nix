{
  services.asusd.enable = true;
  systemd.services.asusd.serviceConfig.ConfigurationDirectory = "asusd";
}
