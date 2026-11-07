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
end
