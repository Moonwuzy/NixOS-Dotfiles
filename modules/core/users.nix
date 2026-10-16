{ pkgs, ... }:

{
  users.users.moonwuzy = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "Moonwuzy";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = [ ];
  };

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

  system.stateVersion = "26.05";
}
