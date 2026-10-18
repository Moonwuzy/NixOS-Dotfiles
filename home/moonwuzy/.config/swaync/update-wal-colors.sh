
#!/usr/bin/env bash
set -euo pipefail

WAL="$HOME/.cache/wal/colors.json"
OUT="$HOME/.config/swaync/wal-colors.css"

if [[ ! -f "$WAL" ]]; then
  echo "pywal colors.json not found: $WAL" >&2
  exit 1
fi

jq -r '
  "@define-color wal_bg " + .special.background + ";\n" +
  "@define-color wal_fg " + .special.foreground + ";\n" +
  "@define-color wal_1 " + .colors.color1 + ";\n" +
  "@define-color wal_2 " + .colors.color2 + ";\n" +
  "@define-color wal_3 " + .colors.color3 + ";\n" +
  "@define-color wal_4 " + .colors.color4 + ";\n" +
  "@define-color wal_5 " + .colors.color5 + ";\n" +
  "@define-color wal_6 " + .colors.color6 + ";\n" +
  "@define-color wal_7 " + .colors.color7 + ";"
' "$WAL" > "$OUT"

swaync-client --reload-css
