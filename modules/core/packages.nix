{ pkgs, inputs, ... }:

{
  home-manager.users.moonwuzy.home.packages = with pkgs; [
    pywal
    nirimod
    blanket
  ];
 
    environment.systemPackages = with pkgs; [
    # My Packages
    inputs.nixgram.packages.${pkgs.stdenv.hostPlatform.system}.default   


    # Misc
    wget
    rustfmt    

    # Desktop
    vivaldi
    kitty
    waybar
    discord
    wofi
    eww
    yazi
    wlogout
    pavucontrol
    libnotify
    ghostty
    zenity
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    qbittorrent
    proton-vpn
    heroic

    qt6.qtdeclarative
    qt6.qt5compat
    qt6.qtsvg
    qt6.qtmultimedia
    qt6.qtsvg
    qt6.qtvirtualkeyboard
    qt6.qtmultimedia
    qt6.qtimageformats

    # Media
    cmus
    mprisence
    nicotine-plus
    cava
    mpv
    spotify
    spotatui

    # Appearance
    waypaper
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
    zoxide
    wayland-utils
    mediawriter
    mission-center
    krita
    usbutils
    zip
    gh
    alsa-lib
    openssl
    pkg-config
    libX11
    libXinerama
    libXcursor

    # Gaming
    wineWow64Packages.stable
    winetricks
    protonplus
    vulkan-loader
    vulkan-tools
    pcsx2
    dolphin-emu
    mangohud
    mangojuice
    itch
    sameboy
    protontricks
    faugus-launcher
    osu-lazer-bin

    # Music
    ardour

    # Graphics / diagnostics
    libva-utils
    xdpyinfo

    # Development
    git
    lazygit

    # VR
    unityhub
    alcom
   
   # Social
    whatsapp-electron
    procps
    cabextract
    vesktop
    ani-cli
    yt-dlp
    ani-skip
    patch
    xdg-user-dirs
    upower
    socat
    mpvpaper
    btop
    godot
    fuse-overlayfs
    
    ryubing
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
}
