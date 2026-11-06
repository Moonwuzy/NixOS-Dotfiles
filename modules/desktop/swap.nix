{

  zramSwap.enable = false;

  boot.kernelParams = [
    "zswap.enabled=1"
    "zswap.compressor=lz4"
    "zswap.zpool=zsmalloc"
    "zswap.max_pool_percent=25"
    "zswap.accept_threshold_percent=90"
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
    "fs.inotify.max_user_watches" = 524288;
    "fs.inotify.max_user_instances" = 1024;
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 40 * 1024;
      priority = 10;
    }
  ];

}
