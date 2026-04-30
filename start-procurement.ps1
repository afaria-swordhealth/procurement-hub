# Procurement Hub — Session Launcher
# Usage: .\start-procurement.ps1  (or double-click in Explorer)
# Opens 3 Windows Terminal tabs in the project directory.
#   A — Operational  : run /warm-up --full
#   B — Improve      : run /improve when A completes
#   C — Improve      : parallel improve track

$proj = "C:\Users\SWORD\Documents\GitHub\procurement-hub"

Start-Process wt -ArgumentList (
    "new-tab --title `"A — Operational`" -d `"$proj`" -- claude " +
    "; new-tab --title `"B — Improve`" -d `"$proj`" -- claude " +
    "; new-tab --title `"C — Improve`" -d `"$proj`" -- claude"
)
