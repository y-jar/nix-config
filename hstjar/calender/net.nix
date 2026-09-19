# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3>
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host calender: fleet identity (ssh + dns pins, applied to every host).
# -=-=-=-=-=-=-=-=-=-=-=
# NOTE (IMPORTANT): this file is PURE DATA, not a module - the networking
# module (juajar/sysjar/networking) imports every hstjar/*/net.nix as a
# phone book entry and pins each host's ip (/etc/hosts) + ssh host key
# (/etc/ssh/ssh_known_hosts). optional fields: user (ssh login user on
# this host, default "jar") and knows (hosts THIS one pins - default:
# everyone with a pinnable net.nix; off-lan hosts opt out with [ ]).
# fleet ssh verifies against the pinned key only - ~/.ssh/known_hosts is
# never consulted for fleet hosts, so stale entries can't trigger warnings.
# -=-=-=-=-=-=-=-=-=-=-=
# rebuilt this host? its key changed - re-scan and update the line below:
#   fkey calender.local    (or: ssh-keyscan -t ed25519 calender.local)
# then jc + rebuild the other hosts.
# -=-=-=-=-=-=-=-=-=-=-=
{
  ip = "192.168.1.5"; # stable lan address (dhcp-reserved)
  hostKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINmxywfMQLgLRzRGL7OP6bPzSfdNSgDa3l3S7QIxkm5/"; # scanned 2026-09-19
  # knows = [ ]; # if un commneted, this will mark it as "I only know myself" and will eval other hosts like any other non-delairative system.
}
