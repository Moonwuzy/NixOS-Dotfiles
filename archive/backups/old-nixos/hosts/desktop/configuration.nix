{ config, pkgs, lib, ... }:

{
  imports = [
    ../../modules/nvidia.nix
    ../../modules/gaming.nix
    ../../modules/common.nix
    ./hardware-configuration.nix
     ];
  
  # Desktop hostname
  networking.hostName = "mafuyu";

  networking.firewall.trustedInterfaces = [ "eno1" ];

  networking.extraHosts = ''
  0.0.0.0 test-s1.battleye.com
  0.0.0.0 paradiseenhanced-s1.battleye.com
  ''; 

   users.users.moonwuzy.extraGroups = [
   "video"
   "render"
   ]; 
   
    boot.loader.systemd-boot.enable = true;
    boot.loader.systemd-boot.configurationLimit = 5;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.supportedFilesystems = [ "ntfs" ];
    time.hardwareClockInLocalTime = false;
    
      fileSystems."/mnt/violet" = {
    device = "/dev/disk/by-uuid/4ca3614a-2f66-4983-a33a-d12d58e99a64";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/hdd" = {
    device = "/dev/disk/by-uuid/08BEF504BEF4EAD8";
    fsType = "ntfs3";
    options = [
      "nofail"
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

    home-manager.users.moonwuzy = {
     
    xdg.configFile."sway/desktop.conf".text = ''
    # Cursor
    seat * xcursor_theme Adwaita 20 
   '';  

    xdg.configFile."waybar/config".source =
      ../../home/moonwuzy/.config/waybar/desktop-config;

   xdg.configFile."waybar/style.css".source =
   lib.mkForce ../../home/moonwuzy/.config/waybar/desktop-style.css;

   xdg.configFile."wofi/style.css".source =
    lib.mkForce ../../home/moonwuzy/.config/wofi/desktop-style.css;

    xdg.configFile."kitty/kitty.conf".source =
    lib.mkForce ../../home/moonwuzy/.config/kitty/desktop-kitty.conf;
  };
}
