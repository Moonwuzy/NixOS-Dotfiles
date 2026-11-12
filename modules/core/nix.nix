{ pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ 
    "https://cache.nixos.org/"
    "https://nix-gaming.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
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
    # Graphics
    libGL
    libGLX
    mesa
    libgbm
    libdecor

    # X11 / Wayland
    libX11
    libxcb
    xcb-util-cursor
    libxkbcommon
    wayland

    # Runtime
    fontconfig
    stdenv.cc.cc.lib
    nss
    nspr

    # Networking
    curlFull
  ];
 };
}
