{ lib, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core/boot.nix
    ../../modules/core/networking.nix
    ../../modules/core/nix.nix
    ../../modules/core/users.nix
    ../../modules/core/audio.nix
    ../../modules/core/services.nix
    ../../modules/core/sway.nix
    ../../modules/core/gaming.nix
    ../../modules/core/packages.nix
    ../../modules/desktop/zram.nix
    ../../modules/desktop/swap.nix
    ../../modules/desktop/graphics.nix
  ];

  networking.hostName = "mafuyu";
  networking.firewall.trustedInterfaces = [ "eno1" ];
  networking.extraHosts = ''
    0.0.0.0 test-s1.battleye.com
    0.0.0.0 paradiseenhanced-s1.battleye.com
  '';

  users.users.moonwuzy.extraGroups = [ "video" "render" ];

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
    options = [ "nofail" "uid=1000" "gid=100" "umask=022" ];
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
