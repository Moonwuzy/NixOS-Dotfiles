{ lib, pkgs, ... }:

{
  # Home Manager backup policy: preserve conflicting files instead of overwriting them.
  home-manager.backupCommand = ''
    target="$1"
    backup="$target.backup-$(date +%Y%m%d-%H%M%S)-$$"
    while [ -e "$backup" ] || [ -L "$backup" ]; do
      backup="$target.backup-$(date +%Y%m%d-%H%M%S)-$$-$RANDOM"
    done
    mv -- "$target" "$backup"
  '';

  home-manager.users.moonwuzy = { pkgs, ... }: {
    home.stateVersion = "26.05";
    
    nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "posy-cursors"	
    ];
    
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
        name = "Posy_Cursor";
        package = pkgs.posy-cursors;
        size = 32;
      };
   };
      home.sessionVariables = {
      XCURSOR_THEME = "Posy_Cursor";
      XCURSOR_SIZE = "32";
      };

    dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";

    home.file."Pictures/Wallpapers/violet.jpg".source =
      ../../home/moonwuzy/Pictures/Wallpapers/violet.jpg;

    xdg.configFile."pipewire/pipewire.conf.d/10-xrun-fix.conf".text = ''
      context.properties = {
        default.clock.rate = 48000
        default.clock.allowed-rates = [ 48000 ]
        default.clock.quantum = 512
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
  
  # Services
  services.xserver.enable = true;
  services.xserver.dpi = 96;
  services.desktopManager.plasma6.enable = false;
  services.upower.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.lact.enable = true; 
  services.clamav = {
    daemon.enable = true;
    updater.enable = true;
  };

   
  # Greeter
  users.groups.greeter = {};

  users.users.greeter = {
    isSystemUser = true;
    group = "greeter";
  };

    services.displayManager.noctalia-greeter = {
    enable = true;
    passwordlessSyncUsers = [ "moonwuzy" ];

    settings = {
      appearance.hide_logo = true;
      output = {
      name = "DP-2";
      mode = "2560x1440@180";
      };
    };
  };

  services.greetd.settings.default_session.user = "greeter"; 
  
  # Vice
  services.vice.enable = true;
   
  programs.dconf.enable = true;
  programs.xfconf.enable = true;

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override { cudaSupport = true; };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

}
