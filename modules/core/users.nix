{ pkgs, ... }:

{
  users.users.moonwuzy = {
    isNormalUser = true;
    shell = pkgs.fish;
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

  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      rebuild = "sudo nixos-rebuild switch";
    };
  };
  system.stateVersion = "26.05";
}
