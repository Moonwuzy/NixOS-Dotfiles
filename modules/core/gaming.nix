{ pkgs, inputs, ... }:

{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    fontPackages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      source-han-sans
      source-han-serif
    ];
  };

  programs.xwayland.enable = true;
  programs.gamemode.enable = true;
  programs.gamescope.enable = true;

  environment.systemPackages = [ pkgs.prismlauncher ];

  services.flatpak.enable = true;
  services.flatpak.packages = [ "com.github.tchx84.Flatseal" ];

  services.monado = {
    enable = true;
    defaultRuntime = true;
  };

  systemd.user.services.monado.environment = {
    STEAMVR_LH_ENABLE = "1";
    XRT_COMPOSITOR_COMPUTE = "1";
  };
}
