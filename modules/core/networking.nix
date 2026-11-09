{
  networking.networkmanager.enable = true;

  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
    	General = {
	ControllerMode = "dual";
	FastConnectable = true;

     };
    };
  };

  services.blueman.enable = true;

  services.udev.extraRules = ''
  ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0029", TEST=="power/control", ATTR{power/control}="on"
'';

}
