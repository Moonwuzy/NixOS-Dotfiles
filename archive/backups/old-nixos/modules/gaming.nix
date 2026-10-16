{ pkgs, inputs, ...}:
{
   imports = [
   inputs.nix-flatpak.nixosModules.nix-flatpak
   ];

   nixpkgs.config.allowUnfree = true;
   
   # Steam
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
   # XWayland
   programs.xwayland.enable = true;

   # Gamemode
   programs.nix-ld.enable = true;
   programs.gamemode.enable = true;
   programs.gamescope.enable = true;
   
   environment.systemPackages = [
      pkgs.prismlauncher
      
   ];

   # Flatpak
   services.flatpak.enable = true;

   services.flatpak.packages = [
   "com.github.tchx84.Flatseal"
   ];


   # Virtual Reality
   services.monado = {
   enable = true;
   defaultRuntime = true; # Register as default OpenXR runtime
   };
   systemd.user.services.monado.environment = {
   STEAMVR_LH_ENABLE = "1";
   XRT_COMPOSITOR_COMPUTE = "1";
   };
}
