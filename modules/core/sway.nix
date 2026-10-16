{ pkgs, ... }:

{
  programs.sway = {
    enable = true;
    package = pkgs.swayfx;
    wrapperFeatures.gtk = true;
    extraOptions = [ "--unsupported-gpu" ];
  };

  home-manager.users.moonwuzy = {
    xdg.configFile."sway/config".source =
      ../../home/moonwuzy/.config/sway/config;

    xdg.configFile."waybar/style.css".source =
      ../../home/moonwuzy/.config/waybar/style.css;

    xdg.configFile."wofi/config".source =
      ../../home/moonwuzy/.config/wofi/config;

    xdg.configFile."wofi/style.css".source =
      ../../home/moonwuzy/.config/wofi/style.css;

    xdg.configFile."kitty/kitty.conf".source =
      ../../home/moonwuzy/.config/kitty/kitty.conf;

    xdg.configFile."ghostty/config".source =
      ../../home/moonwuzy/.config/ghostty/config;
  };
}
