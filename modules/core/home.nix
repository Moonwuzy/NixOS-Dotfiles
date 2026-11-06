{ ... }:

{
  home-manager.users.moonwuzy = {
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "ski.desktop";
      };
    };
  };
}
