# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Shared known-tablet catalog: device -> mango monitor spec.
# -=-=-=-=-=-=-=-=-=-=-=
# Consumed by juajar/liijar/options.nix to default usrset.tabletenable.<key>.match,
# so a host only writes:   tabletenable.xppen.enable = true;
#
# FIND A TABLET DISPLAY'S IDENTITY IN A TERMINAL
#   for e in /sys/class/drm/card*-*/edid; do
#     echo "$e: $(strings "$e" | tr '\n' ' ')"
#   done
#   # -> .../card1-DP-2/edid: ... Artist13.3pro 20200316 ...
# Then match on **model** (recommended, survives replugging into another port):
#   "model:Artist13.3pro"
#
# mango monitor-spec keys (join with '&&' for more than one):
#   name:<regex>   connector name, e.g. "name:^DP-2$"
#   model:<str>    EDID product name  <-- preferred
#   serial:<str>   EDID serial
# Avoid make:<str>: mango/wlroots resolves the EDID manufacturer from its own
# hardcoded PNP table (often "Unknown"), so raw codes like "UGD" will NOT match.
# Copy a block below to add a new tablet; the key is what you enable in user.nix.
{
  xppen = {
    # XP-Pen Artist 13.3 Pro (EDID: UGD / Artist13.3pro / 20200316)
    match = "model:Artist13.3pro";
  };
}
