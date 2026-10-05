{ config, pkgs, ... }:

{
  # ============================================================
  # SHARED CONFIGURATION
  # This is used by BOTH the laptop and desktop.
  # ============================================================

  # Home Manager
  home-manager.users.moonwuzy = { pkgs, ... }: {
    home.stateVersion = "26.05";

       home.packages = with pkgs; [
      pywal
      ];
           xdg.configFile."wal/templates/dunstrc".source =
      ../home/moonwuzy/.config/wal/templates/dunstrc;

        home.file."Pictures/Wallpapers/violet.jpg".source =
      ../home/moonwuzy/Pictures/Wallpapers/violet.jpg;

    home.pointerCursor = {
      enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 28;

      gtk.enable = true;
      sway.enable = true;
    };

  # ============================================================
  # Shared GUI configuration
  # ============================================================

  xdg.configFile."sway/config".source =
    ../home/moonwuzy/.config/sway/config;

  xdg.configFile."waybar/style.css".source =
    ../home/moonwuzy/.config/waybar/style.css;

  xdg.configFile."wofi/config".source =
    ../home/moonwuzy/.config/wofi/config;

  xdg.configFile."wofi/style.css".source =
    ../home/moonwuzy/.config/wofi/style.css;

  xdg.configFile."kitty/kitty.conf".source =
    ../home/moonwuzy/.config/kitty/kitty.conf;
  };

  # Cursor
  environment.variables = {
    XCURSOR_SIZE = "32";
    SWAY_UNSUPPORTED_GPU = "true";
  };

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "America/Edmonton";
  i18n.defaultLocale = "en_CA.UTF-8";

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Desktop / Greeter
  programs.dconf.enable = true;

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd 'sway --unsupported-gpu'";
        user = "greeter";
      };
    };
  };

  security.polkit.enable = true;
  security.pam.services.swaylock = {};

  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Services
  services.udisks2.enable = true;
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

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # User
  users.users.moonwuzy = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Moonwuzy";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [];
  };

  # Sudo
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

  # ============================================================
  # PROGRAMS
  # ============================================================

  # SwayFX
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
  };

  # Thunar
  programs.xfconf.enable = true;

  programs.thunar = {
    enable = true;

    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

  # Zsh
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

  # Steam
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

  # ============================================================
  # GRAPHICS
  # ============================================================

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
    ];
  };

  # Shared NVIDIA environment
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    QT_SCALE_FACTOR = "1.5";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # ============================================================
  # PACKAGES
  # ============================================================

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl

    # Desktop
    vivaldi
    kitty
    waybar
    discord
    wofi
    yazi
    wlogout
    pavucontrol
    swaynotificationcenter
    libnotify

    # Media
    cmus
    nicotine-plus
    cava

    # Appearance
    pywal
    waypaper
    swaybg

    # Utilities
    fastfetch
    autotiling
    glib
    flameshot
    grim
    slurp
    tumbler
    ffmpegthumbnailer
    loupe
    p7zip
    file-roller
    blueman

    # Gaming
    wineWow64Packages.stable
    winetricks
    vulkan-loader
    vulkan-tools
    pcsx2

    # Graphics / diagnostics
    libva-utils
    xdpyinfo

    # Development
    git
  ];

  # ============================================================
  # FONTS
  # ============================================================

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

  # Nixpkgs
  nixpkgs.config.allowUnfree = true;

  # State version
  system.stateVersion = "26.05";
}
