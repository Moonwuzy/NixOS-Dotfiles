{ config, lib, pkgs, inputs, ... }:

{

  
# CachyOS Kernel
boot.kernelPackages =
inputs.nix-cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages-cachyos-lts;

# NixOS Kernel
# boot.kernelPackages = pkgs.linuxPackages;

# Swap
 zramSwap = {
 enable = true;
 algorithm = "zstd";
 memoryPercent = 50;
 priority = 100;
 };

# boot.kernel.sysctl = {
 # "vm.swappiness" = 100;
  #"vm.page-cluster" = 0;
  #"vm.vfs_cache_pressure" = 50;
  #"vm.watermark_boost_factor" = 0;
  #"vm.watermark_scale_factor" = 125;
  #"vm.max_map_count" = 2147483642;
#};

swapDevices = [
  {
    device = "/swapfile";
    size = 40 * 1024;
    priority = 10;
  }
];

# CachyOS binary cache
nix.settings = {
  substituters = [
    "https://cache.nixos.org/"
  ];

  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
};

  # Home Manager: automatically preserve conflicting files
  home-manager.backupCommand = ''
    target="$1"
    backup="$target.backup-$(date +%Y%m%d-%H%M%S)-$$"
    while [ -e "$backup" ] || [ -L "$backup" ]; do
      backup="$target.backup-$(date +%Y%m%d-%H%M%S)-$$-$RANDOM"
    done
    mv -- "$target" "$backup"
  '';

  # Home Manager
    home-manager.users.moonwuzy = { pkgs, ... }: {
    home.stateVersion = "26.05";

      # Theme
      gtk = {
      enable = true;
      colorScheme = "dark";

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      iconTheme = {
        name = "Adwaita-Dark";
        package = pkgs.adwaita-icon-theme;
      };

      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
        size = 20;
      };
      };
      dconf.settings."org/gnome/desktop/interface".color-scheme =
      "prefer-dark";
       

       home.packages = with pkgs; [
       pywal
      ];
        
      home.file."Pictures/Wallpapers/violet.jpg".source =
      ../home/moonwuzy/Pictures/Wallpapers/violet.jpg;
      
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

      xdg.configFile."ghostty/config".source =
      ../home/moonwuzy/.config/ghostty/config;
      
      # PipeWire xrun / crackling fix
    xdg.configFile."pipewire/pipewire.conf.d/10-xrun-fix.conf".text = ''
      context.properties = {
        default.clock.rate = 48000
        default.clock.allowed-rates = [ 48000 ]
        default.clock.quantum = 256
        default.clock.min-quantum = 128
        default.clock.max-quantum = 1024
      }
    '';

          xdg.configFile."openxr/1/active_runtime.json".text = ''
      {
        "file_format_version": "1.0.0",
        "runtime": {
          "VALVE_runtime_is_steamvr": true,
          "library_path": "/home/moonwuzy/.local/share/Steam/steamapps/common/SteamVR/steamxr_linux64.json",
          "name": "SteamVR"
        }
      }
    '';      
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
  services.greetd.enable = lib.mkForce false;

  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = false;

  services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
  };
  
  programs.qylock = {
  enable = true;
  theme = "pixel-coffee";
  };

hardware.opentabletdriver.enable = true;
hardware.uinput.enable = true;
boot.kernelModules = [ "uinput" ];


nixpkgs.overlays = [
  (final: prev: {
    sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
      postInstall = (old.postInstall or "") + ''
        substituteInPlace $out/share/wayland-sessions/sway.desktop \
          --replace-fail 'Exec=sway' 'Exec=sway --unsupported-gpu'
      '';
    });
  })
];
  
  # Nix
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Services
  services.udisks2.enable = true;
  services.xserver.dpi = 96;
  services.gvfs.enable = true;
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
  
  # Keyring
  services.gnome.gnome-keyring.enable = true;

  # ============================================================
  # PROGRAMS
  # ============================================================
  
  # Dconf
  programs.dconf.enable = true;

  # Sway
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];
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
   
   # OBS
   programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {cudaSupport = true;};
   };
   
   # App Images
   programs.appimage = {
  enable = true;
  binfmt = true;
  };

  # Vortex
  programs.direnv = {
  enable = true;
  enableZshIntegration = true;
  nix-direnv.enable = true;
  };
  
  # Fluorine Manager
    programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
    libGL
    libGLX
    mesa
    libgbm
    libX11
    libxcb
    xcb-util-cursor
    libxkbcommon
    wayland
    fontconfig
    stdenv.cc.cc.lib
    nss
    nspr
  ];
};

  # ============================================================
  # PACKAGES
  # ============================================================

  environment.systemPackages = with pkgs; [
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
    ghostty
    zenity
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
   
    # Qylock / SDDM Qt 6 dependencies
    qt6.qtdeclarative
    qt6.qt5compat
    qt6.qtsvg
    qt6.qtmultimedia

    # Video playback
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly

    # Media
    cmus
    nicotine-plus
    cava
    mpv
    spotify

    # Appearance
    pywal
    waypaper
    swaybg
    papirus-icon-theme
    gnome-themes-extra
    catppuccin-sddm
    

    # Utilities
    fastfetch
    xdg-utils
    autotiling
    glib
    grim
    slurp
    tumbler
    ffmpegthumbnailer
    loupe
    p7zip
    file-roller
    blueman
    keepassxc
    jq
    wl-clipboard
    emacs
    ripgrep
    fd
    neovim
    vscodium
    pnpm
    nodejs
    cargo
    rustc
    gcc
    python3
    gnumake
    easyeffects
    fzf
    zsh-fzf-tab
    wayland-utils
    mediawriter
    mission-center
    krita
    usbutils
    zip

    # Gaming
    wineWow64Packages.stable
    winetricks
    vulkan-loader
    vulkan-tools
    pcsx2
    dolphin-emu
    mangohud
    itch
    sameboy
    steamtinkerlaunch
    protontricks
    
    # Music
    ardour 
 
    # Graphics / diagnostics
    libva-utils
    xdpyinfo

    # Development
    git

    # VR
    unityhub
    alcom
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

  # State version
  system.stateVersion = "26.05";
}
