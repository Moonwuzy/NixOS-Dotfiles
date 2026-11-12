
{ pkgs, inputs, lib, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  # ============================================================
  # HOME MANAGER
  # ============================================================

  home-manager.users.moonwuzy.home.file.".config/fish/config.fish".source =
    ../../home/moonwuzy/.config/fish/config.fish;


  # ============================================================
  # SYSTEM SETTINGS
  # ============================================================

  # Disable Nano.
  programs.nano.enable = false;

  # Exclude XTerm from X server packages.
  services.xserver.excludePackages = [ pkgs.xterm ];

  # Disable the XTerm desktop manager.
  services.xserver.desktopManager.xterm.enable = false;

  # Remove NixOS default packages.
  environment.defaultPackages = lib.mkForce [];


  # ============================================================
  # DEFAULT EDITOR
  # ============================================================

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

    nixpkgs.config.permittedInsecurePackages = [
    "qutebrowser-3.7.0"
    ];


    # ============================================================
    # SYSTEM PACKAGES
    # ============================================================

    environment.systemPackages = with pkgs; [

    # ----------------------------------------------------------
    # CUSTOM APPLICATIONS
    # ----------------------------------------------------------

    inputs.nixgram.packages.${system}.default
    inputs.yapfast.packages.${pkgs.stdenv.hostPlatform.system}.yapfast

    # ----------------------------------------------------------
    # NETWORKING & DOWNLOADS
    # ----------------------------------------------------------

    wget
    proton-vpn
    qbittorrent
    gh

    # ----------------------------------------------------------
    # WEB BROWSERS
    # ----------------------------------------------------------

    vivaldi
    inputs.zen-browser.packages.${system}.default
    qutebrowser

    # ----------------------------------------------------------
    # TERMINALS & SHELL UTILITIES
    # ----------------------------------------------------------

    kitty
    ghostty
    starship
    fzf
    zoxide
    bat
    eza
    yazi
    trash-cli
    circumflex
    btop
    fastfetch
    icu 

    # ----------------------------------------------------------
    # WINDOW MANAGEMENT & DESKTOP
    # ----------------------------------------------------------
    
    grim
    slurp
    libnotify
    kanagawa-icon-theme
    gnome-themes-extra 

    # ----------------------------------------------------------
    # AUDIO & MEDIA
    # ----------------------------------------------------------

    discord
    whatsapp-electron
    cmus
    kew
    spotify
    cava
    mpv
    easyeffects

    # ----------------------------------------------------------
    # DEVELOPMENT & PROGRAMMING
    # ----------------------------------------------------------

    neovim
    vscodium
    git
    rustfmt
    rustc
    cargo
    gcc
    gnumake
    python3
    nodejs
    pnpm
    godot
    pkg-config
    openssl

    # ----------------------------------------------------------
    # QT FRAMEWORK
    # ----------------------------------------------------------

    qt6.qtdeclarative
    qt6.qt5compat
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qtvirtualkeyboard
    qt6.qtimageformats

    # ----------------------------------------------------------
    # FILE MANAGEMENT & ARCHIVES
    # ----------------------------------------------------------

    file-roller
    p7zip
    zip
    tumbler
    ffmpegthumbnailer
    loupe
    xdg-utils
    xdg-user-dirs
    fuse-overlayfs

    # ----------------------------------------------------------
    # GAMING & EMULATION
    # ----------------------------------------------------------

    wineWow64Packages.stable
    winetricks
    protonplus
    protontricks
    heroic
    faugus-launcher
    itch
    pcsx2
    dolphin-emu
    sameboy
    ryubing
    osu-lazer-bin
    vulkan-loader
    vulkan-tools
    mangohud
    mangojuice
    unityhub

    # ----------------------------------------------------------
    # GRAPHICS & CREATIVE APPLICATIONS
    # ----------------------------------------------------------

    krita
    libva-utils
    xdpyinfo

    # ----------------------------------------------------------
    # SYSTEM UTILITIES & HARDWARE
    # ----------------------------------------------------------

    procps
    usbutils  
    alsa-lib
    upower
    mission-center
    socat
    cabextract
    ripgrep
    fd
    jq
    libX11
    libXinerama
    libXcursor
    xinit
    glib
    nicotine-plus
    keepassxc
    wayland-utils
    ani-cli
    yt-dlp
    ani-skip
    patch
    zstd

  ];


  # ============================================================
  # FONT CONFIGURATION
  # ============================================================

  fonts = {
    fontDir.enable = true;
    enableGhostscriptFonts = true;

    packages = with pkgs; [

      # General purpose fonts.
      cantarell-fonts
      inter
      liberation_ttf
      ubuntu-classic

      # Monospaced and programming fonts.
      hack-font
      jetbrains-mono
      monaspace

      # International and Unicode fonts.
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji

      # Additional programming fonts.
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts

    ] ++ builtins.filter lib.isDerivation
      (builtins.attrValues pkgs.nerd-fonts);
  };
}

