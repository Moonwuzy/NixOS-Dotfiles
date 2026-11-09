if status is-interactive
    # Greeting
    set -g fish_greeting ""
    # Autosuggestions
    set -g fish_autosuggestion_enabled 1

    # Aliases
    alias ll "ls -lah"
    alias rebuild "sudo nixos-rebuild switch"
 
    # Starship
    starship init fish | source

    # Zoxide
    zoxide init fish | source
   
    # Fuzzy
    fzf --fish | source

    # Fish
    fish_add_path --global ~/.local/bin

    # Path Fixe
    set -gx LD_LIBRARY_PATH /nix/store/w188i9aj0jn0x1r7c3f5dzahpq1nn5cl-libgpg-error-1.61/lib:$LD_LIBRARY_PATH
end
