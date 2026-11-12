{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    git
    neovim
    fastfetch
    curl
    wget
  ];
}
