{ pkgs, lib, inputs, ... }:

 {
  
  boot.kernelPackages =  pkgs.linuxPackages_zen;

  boot.kernelModules = [
    "uinput"
    "tcp_bbr3"
  ];

  boot.kernelPatches = [
    {
      name = "zen-pds-scheduler";
      patch = null;
      structuredExtraConfig = with lib.kernel; {
        SCHED_ALT = yes;
        SCHED_PDS = yes;
        SCHED_BMQ = no;

       SCHED_AUTOGROUP = lib.mkForce unset;
       SCHED_CLASS_EXT = lib.mkForce unset;
       SCHED_CORE = lib.mkForce unset;
      };
    }
  ];

  # CachyOS Kernel ( Don't use fucker)
  # inputs.nix-cachyos-kernel.legacyPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages-cachyos-latest;

  boot.kernel.sysctl = {
  # TCP
  "net.core.default_qdisc" = "fq";
  "net.ipv4.tcp_congestion_control" = "bbr3";

  # Memory tuning
  "vm.watermark_boost_factor" = 0;
  "vm.compact_unevictable_allowed" = 0;
  "vm.compaction_proactiveness" = 0;
  };

  # AMD P-State EPP
  systemd.services.amd-pstate-epp = {
    description = "Set AMD P-State EPP to performance";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      for policy in /sys/devices/system/cpu/cpufreq/policy*; do
        [ -e "$policy/energy_performance_preference" ] || continue
        echo performance > "$policy/energy_performance_preference"
      done
    '';
  };

  # Keep the systemd-boot setup shared by both installations.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware.opentabletdriver.enable = true;
  hardware.uinput.enable = true;
  
}
