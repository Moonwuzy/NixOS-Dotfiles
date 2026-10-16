{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://cache.nixos.org/" ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  nixpkgs.overlays = [
    (final: prev: {
      sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          substituteInPlace $out/share/wayland-sessions/sway.desktop \
            --replace-fail 'Exec=sway' 'Exec=sway --unsupported-gpu'
        '';
      });
    })
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      libGL libGLX mesa libgbm libX11 libxcb xcb-util-cursor
      libxkbcommon wayland fontconfig stdenv.cc.cc.lib nss nspr
    ];
  };
}
