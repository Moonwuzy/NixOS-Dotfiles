{ ... }:

{
  home-manager.users.moonwuzy = {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "ski.desktop";
	"text/html" = [ "vivaldi-stable.desktop" ];
        "application/xhtml+xml" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/http" = [ "vivaldi-stable.desktop" ];
        "x-scheme-handler/https" = [ "vivaldi-stable.desktop" ];
      };
    };
  };
}
