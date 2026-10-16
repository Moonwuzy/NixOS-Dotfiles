
# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];
  
  home-manager.users.moonwuzy = { pkgs, ... }: {
    home.stateVersion = "26.05";

    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 28;

      gtk.enable = true;
      sway.enable = true;
    };
  };
 
  # Backlight fix
  boot.kernelParams = [
  "i915.enable_dpcd_backlight=1"
  "nvidia.NVreg_EnableBacklightHandler=0"
  "nvidia.NVreg_RegistryDwords=EnableBrightnessControl=0"
    ];
  # Cursor fix
  environment.variables = {
  XCURSOR_SIZE = "32";
  };
  # Mount
  fileSystems."/mnt/holiday" = {
  device = "/dev/disk/by-uuid/fd8e2d9b-0c7c-43e8-b673-24bcd9aa859b";
  fsType = "ext4";
  options = [ "nofail" ];
  };
     
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
 
  networking.hostName = "yaoilover"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Edmonton";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  # Bluetooth
  hardware.bluetooth = {
  enable = true;
  powerOnBoot = true;
  };
  services.blueman.enable = true;

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  # Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Services  
  services.udisks2.enable = true;
  services.asusd.enable = true;
  systemd.services.asusd.serviceConfig.ConfigurationDirectory = "asusd";
  services.xserver.dpi = 96;
  services.gvfs.enable = true;
  services.flatpak.enable = true;
  services.tumbler.enable = true;
  # Audio
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
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."moonwuzy" = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Moonwuzy";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
   
  security.sudo.extraRules = [
  {
    users = [ "moonwuzy" ];
    commands = [
      {
        command = "ALL";
        options = [ "NOPASSWD" ];
      }
    ];
  }
];

  # --- Programs ---
                                                                                       
  # Thunar
  programs.xfconf.enable = true;
  programs.thunar = {
  enable = true;
  plugins = with pkgs; [
    thunar-volman
    thunar-archive-plugin
    ];
  };
  programs.zsh = {
  enable = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  
  enableCompletion = true;
  shellAliases = {
    ll = "ls -lah";
    rebuild = "sudo nixos-rebuild switch";
    };
  };
  programs.steam = {
  enable = true;

  fontPackages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    source-han-sans
    source-han-serif
  ];
};
  programs.nix-ld.enable = true;

  # === NVIDIA CONFIGURATION ===
 
  hardware.graphics = {
  enable = true;
  enable32Bit = true;
  extraPackages = with pkgs; [
  # Intel Arc / Meteor Lake video acceleration
  intel-media-driver
  vpl-gpu-rt 
    ];
  };
  # Intel + NVIDIA
  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
    ];

  hardware.nvidia = {
  modesetting.enable = true;
  open = true;
  nvidiaSettings = true;
 
  # Needed for proper laptop NVIDIA power management
  powerManagement.enable = true;
  powerManagement.finegrained = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;

  prime = {
    offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    };
  };


  environment.variables = {
  SWAY_UNSUPPORTED_GPU = "true";
  };
  environment.sessionVariables = {
  GBM_BACKEND = "nvidia-drm";
  WLR_NO_HARDWARE_CURSORS = "1";
  QT_SCALE_FACTOR = "1.5";
  MOZ_DISABLE_RDD_SANDBOX= "1" ;
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
 
  # === END OF NVIDIA CONFIGURATION ===

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).

  environment.systemPackages = with pkgs; [
  vim
  wget
  curl
  vivaldi
  kitty
  waybar
  discord
  wofi
  yazi
  pywal
  waypaper
  swaybg
  libva-utils
  xdpyinfo
  wlogout
  pavucontrol
  cmus
  nicotine-plus
  fastfetch
  autotiling
  glib
  flameshot
  grim
  slurp
  tumbler
  ffmpegthumbnailer
  loupe
  wineWow64Packages.stable
  winetricks
  vulkan-loader
  vulkan-tools
  git
  swaynotificationcenter
  libnotify
  pcsx2
  p7zip
  file-roller
  blueman
  cava
  ];

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;
    packages = with pkgs; [
      cantarell-fonts
      hack-font
      inter
      jetbrains-mono
      liberation_ttf
      monaspace
      noto-fonts
      ubuntu-classic

      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      nerd-fonts.jetbrains-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
    ];
};
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
