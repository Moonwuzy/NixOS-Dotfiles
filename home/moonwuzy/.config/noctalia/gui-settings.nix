# Noctalia settings, mirrored from the GUI by the dmopp/settings-to-nix plugin
# (/home/moonwuzy/.local/state/noctalia/settings.toml). Every export overwrites this file.
#
# This file is your backup: keep it somewhere safe, for example in git.
#
# To restore, run this as your user in the directory of this file:
#   $(nix-build --no-out-link ./gui-settings.nix)/bin/noctalia-restore-settings
# It replaces settings.toml (the old one is kept as settings.toml.bak-<time>).
# Then restart Noctalia; it installs the plugins listed here again on startup.
{ pkgs ? import <nixpkgs> { } }:
let
  settings = {
    bar = {
      Moonwuzy = {
        background_opacity = 0.74999998323619366;
        enabled = true;
        end = [
          "tray"
          "notifications"
          "clipboard"
          "updates"
          "network"
          "bluetooth"
          "volume"
          "brightness"
          "battery"
          "control-center"
          "session"
        ];
        font_family = "JetBrains Mono";
        font_weight = 700;
        margin_ends = 0;
        radius = 0;
        start = [ "launcher" "workspaces" "widget" "bar_2" "bar" "bar_3" ];
      };
      default.enabled = false;
      order = [ "default" "Moonwuzy" ];
    };
    calendar = {
      account.personal_google.type = "google";
      enabled = true;
    };
    config_version = 16;
    control_center.calendar.hide_past_events = true;
    dock = {
      active_monitor_only = true;
      background_opacity = 0.74999998323619366;
      border_width = 1.5;
      compositor_blur = false;
      concave_edge_corners = false;
      enabled = true;
      magnification = false;
      margin_edge = 2;
      radius_bottom_left = 18;
      radius_top_left = 11;
      reserve_space = false;
      show_dots = true;
      smart_auto_hide = true;
    };
    location.auto_locate = true;
    lockscreen_widgets = {
      enabled = false;
      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };
      schema_version = 2;
      widget = {
        "lockscreen-login-box@DP-1" = {
          box_height = 196.0;
          box_width = 810.0;
          cx = 1280.0;
          cy = 1258.0;
          output = "DP-1";
          placement_height = 1440.0;
          placement_width = 2560.0;
          rotation = 0.0;
          settings = {
            background_color = "surface_container";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_password_reveal = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
          type = "login_box";
        };
        "lockscreen-login-box@DP-2" = {
          box_height = 196.0;
          box_width = 810.0;
          cx = 1280.0;
          cy = 1258.0;
          output = "DP-2";
          placement_height = 1440.0;
          placement_width = 2560.0;
          rotation = 0.0;
          settings = {
            background_color = "surface_container";
            background_opacity = 0.88;
            background_radius = 12.0;
            center_password_text = false;
            input_opacity = 1.0;
            input_radius = 6.0;
            layout = "regular";
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
            show_media = true;
            show_password_reveal = true;
            show_session_buttons = true;
            show_unlock_hint = true;
            show_weather = true;
          };
          type = "login_box";
        };
      };
      widget_order = [ "lockscreen-login-box@DP-1" "lockscreen-login-box@DP-2" ];
    };
    notification = {
      background_opacity = 0.74999998323619366;
      monitors = [ "DP-2" ];
    };
    plugin_settings = {
      "dmopp/nixos-updates" = {
        nixos_configuration = "desktop";
        notify = false;
        update_command = "nix flake update --flake /etc/nixos &&\nsudo nixos-rebuild switch --flake /etc/nixos#desktop &&\nflatpak update -y";
      };
      "noctalia/mpvpaper".video_directory = "/home/moonwuzy/Videos/Video Wallpapers";
    };
    plugins.enabled = [
      "dmopp/nixos-updates"
      "noctalia/wallhaven"
      "noctalia/world_clock"
      "mindnbytes/nix-status"
      "dmopp/settings-to-nix"
      "salemsayed/niri-active-workspace"
      "raycursive/discord-voice"
      "tphilippot/git_companion"
      "riversyx/noctaproton-vpn"
      "noctalia/mpvpaper"
      "prponkshe/umbriel-displays"
    ];
    shell = {
      animation.speed = 0.80000001192092896;
      launcher = {
        default_view = "all";
        pinned = [ "steam" "dev.stormix.deadlock-mod-manager" ];
      };
    };
    theme = {
      builtin = "Ayu";
      community_palette = "Oxocarbon";
      mode = "dark";
      source = "wallpaper";
      templates = {
        builtin_ids = [ "cava" "emacs" "gtk3" "gtk4" "kitty" "qt" ];
        community_ids = [ "discord" ];
      };
      wallpaper_scheme = "m3-content";
    };
    wallpaper.directory = "/home/moonwuzy/Pictures/Wallpapers";
    widget = {
      bar = {
        show_channel_name = false;
        type = "raycursive/discord-voice:bar";
      };
      bar_2.type = "riversyx/noctaproton-vpn:bar";
      bar_3.type = "prponkshe/umbriel-displays:bar";
      tray.hidden = [ "Blueman" "EasyEffects" ];
      updates.type = "dmopp/nixos-updates:updates";
      widget.type = "tphilippot/git_companion:widget";
      workspaces = {
        hide_when_empty = true;
        show_labels = false;
      };
    };
  };
  settingsToml = (pkgs.formats.toml { }).generate "noctalia-settings.toml" settings;
in
(pkgs.writeShellScriptBin "noctalia-restore-settings" ''
  set -eu
  PATH=${pkgs.coreutils}/bin:$PATH
  if [ -n "''${NOCTALIA_STATE_HOME:-}" ]; then
    dir="$NOCTALIA_STATE_HOME/noctalia"
  elif [ -n "''${XDG_STATE_HOME:-}" ]; then
    dir="$XDG_STATE_HOME/noctalia"
  else
    dir="$HOME/.local/state/noctalia"
  fi
  mkdir -p "$dir"
  if [ -e "$dir/settings.toml" ]; then
    backup="$dir/settings.toml.bak-$(date +%Y%m%d-%H%M%S)"
    cp "$dir/settings.toml" "$backup"
    echo "Previous settings saved to $backup"
  fi
  tmp=$(mktemp "$dir/.settings.toml.XXXXXX")
  cat ${settingsToml} > "$tmp"
  chmod 644 "$tmp"
  mv "$tmp" "$dir/settings.toml"
  # Skip the first-run wizard; it would write its own choices over the restored ones.
  touch "$dir/.setup-complete"
  echo "Noctalia settings restored to $dir/settings.toml."
  echo "Restart Noctalia so it installs the plugins from the restored settings."
'') // { inherit settings; }
