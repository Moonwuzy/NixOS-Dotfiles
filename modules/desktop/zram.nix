{
  zramSwap = {
    enable = true;
    algorithm = "lz4";
    memoryPercent = 40;
    priority = 100;
  };

boot.kernel.sysctl = {
    "vm.swappiness" = 20;
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };
}
