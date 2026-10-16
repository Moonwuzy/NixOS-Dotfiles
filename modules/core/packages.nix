{ pkgs, inputs, ... }:

{
  home-manager.users.moonwuzy.home.packages = with pkgs; [
    pywal
  ];

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
