
{ config, lib, pkgs, ... }:

let
  tracker = pkgs.writeText "system-usage-tracker.py" ''
    import signal
    import time
    from pathlib import Path

    state = Path("/var/lib/system-usage/total-seconds")
    total = int(state.read_text()) if state.exists() else 0

    running = True

    def stop(signum, frame):
        global running
        running = False

    signal.signal(signal.SIGTERM, stop)
    signal.signal(signal.SIGINT, stop)

    last = time.monotonic()

    def save():
        temp = state.with_suffix(".tmp")
        temp.write_text(str(total))
        temp.replace(state)

    while running:
        time.sleep(5)

        now = time.monotonic()
        elapsed = now - last

        if elapsed >= 60:
            total += int(elapsed)
            last = now
            save()

    total += int(time.monotonic() - last)
    save()
  '';

  usageDisplay = pkgs.writeShellScriptBin "system-usage-total" ''
    seconds=$(cat /var/lib/system-usage/total-seconds 2>/dev/null || echo 0)

    days=$(awk "BEGIN { printf \"%.2f\", $seconds / 86400 }")

    printf "%s days\n" "$days"
  '';

in {
  environment.systemPackages = [ usageDisplay ];

  systemd.services.system-usage-tracker = {
    description = "Cumulative System Usage Tracker";
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      StateDirectory = "system-usage";
      ExecStart = "${pkgs.python3}/bin/python3 ${tracker}";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}

