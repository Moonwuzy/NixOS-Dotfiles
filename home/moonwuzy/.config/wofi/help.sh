#!/usr/bin/env bash

entries=(
"── WINDOWS ──────────────────────────"
"Super+Enter       Terminal (Ghostty)"
"Super+Q           Close window"
"Super+D           App launcher"
"Super+H           Help menu"
"Super+P           Edit Sway config"
"Super+L           Yazi file manager"
"Super+N           Notifications"
"Super+O           Waypaper"
"Super+B           Wallpaper picker"
"Super+J           Nepu"
"Super+F           Fullscreen"
"Super+Space       Toggle focus mode"
"Super+Shift+Space Floating toggle"
"Super+A           Focus parent"
"Super+W           Resize mode"
"Super+Shift+C     Reload Sway"
"Super+Shift+E     Exit Sway"
""
"── WORKSPACES ───────────────────────"
"Super+1-9 / 0     Switch workspace"
"Super+Shift+1-9/0 Move window"
"Super+Shift+Arrows Move window direction"
"Super+Minus       Show scratchpad"
"Super+Shift+Minus Send to scratchpad"
""
"── SCREEN & MEDIA ───────────────────"
"F11               Full screenshot"
"Print             Area screenshot"
"Volume keys       Volume control"
"Mic mute          Toggle microphone mute"
"Media keys        Playback controls"
"Brightness keys   Screen brightness"
"Ctrl+Alt+Delete   System monitor"
""
"── CONFIG FILES ─────────────────────"
"Flake             /etc/nixos/flake.nix"
"Desktop            /etc/nixos/hosts/desktop/"
"Laptop             /etc/nixos/hosts/laptop/"
"Core modules       /etc/nixos/modules/core/"
"Desktop modules    /etc/nixos/modules/desktop/"
"Laptop modules     /etc/nixos/modules/laptop/"
"Sway               /etc/nixos/home/moonwuzy/.config/sway/config"
"Waybar             ~/.config/waybar/"
"Wofi               ~/.config/wofi/"
"Ghostty            ~/.config/ghostty/"
"Wallpapers         ~/Pictures/Wallpapers/"
"Violet drive       /mnt/violet/"
"Secondary drive    /mnt/hdd/"
""
"── COMMANDS ─────────────────────────"
"Reload Sway        swaymsg reload"
"Outputs            swaymsg -t get_outputs"
"Workspaces         swaymsg -t get_workspaces"
"GPU                nvidia-smi"
"Memory             free -h"
"Kernel             uname -r"
"Desktop rebuild    sudo nixos-rebuild switch --flake /etc/nixos#desktop"
"Laptop rebuild     sudo nixos-rebuild switch --flake /etc/nixos#laptop"
"Validate flake     nix flake check /etc/nixos"
"Update inputs      nix flake update /etc/nixos"
"Kernel logs        journalctl -b -k"
)

selected=$(printf '%s\n' "${entries[@]}" | wofi \
    --dmenu \
    --prompt "Help" \
    --width 620 \
    --height 600 \
    --cache-file /dev/null)

[ -z "$selected" ] && exit 0

case "$selected" in
    "Flake"*)             value="/etc/nixos/flake.nix" ;;
    "Desktop"*)           value="/etc/nixos/hosts/desktop/" ;;
    "Laptop"*)            value="/etc/nixos/hosts/laptop/" ;;
    "Core modules"*)      value="/etc/nixos/modules/core/" ;;
    "Desktop modules"*)   value="/etc/nixos/modules/desktop/" ;;
    "Laptop modules"*)    value="/etc/nixos/modules/laptop/" ;;
    "Sway"*)              value="/etc/nixos/home/moonwuzy/.config/sway/config" ;;
    "Waybar"*)            value="$HOME/.config/waybar/" ;;
    "Wofi"*)              value="$HOME/.config/wofi/" ;;
    "Ghostty"*)           value="$HOME/.config/ghostty/" ;;
    "Wallpapers"*)        value="$HOME/Pictures/Wallpapers/" ;;
    "Violet drive"*)      value="/mnt/violet/" ;;
    "Secondary drive"*)   value="/mnt/hdd/" ;;
    "Reload Sway"*)       value="swaymsg reload" ;;
    "Outputs"*)           value="swaymsg -t get_outputs" ;;
    "Workspaces"*)        value="swaymsg -t get_workspaces" ;;
    "GPU"*)               value="nvidia-smi" ;;
    "Memory"*)            value="free -h" ;;
    "Kernel"*)            value="uname -r" ;;
    "Desktop rebuild"*)   value="sudo nixos-rebuild switch --flake /etc/nixos#desktop" ;;
    "Laptop rebuild"*)    value="sudo nixos-rebuild switch --flake /etc/nixos#laptop" ;;
    "Validate flake"*)    value="nix flake check /etc/nixos" ;;
    "Update inputs"*)     value="nix flake update /etc/nixos" ;;
    "Kernel logs"*)       value="journalctl -b -k" ;;
    *) exit 0 ;;
esac

printf '%s' "$value" | wl-copy
notify-send "Help menu" "Copied: $value"
