# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3>
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host template: fleet identity (ssh + dns pins, applied to every host).
# -=-=-=-=-=-=-=-=-=-=-=
# NOTE (IMPORTANT): this file is PURE DATA, not a module - the networking
# module (juajar/sysjar/networking) imports every hstjar/*/net.nix as a
# phone book entry (identity: ip + hostKey; optional: user, knows).
# -=-=-=-=-=-=-=-=-=-=-=
# fill these in once the host is online (scan the key with the `fkey`
# alias), or leave them null to keep this host out of the fleet pins
# until then.
# -=-=-=-=-=-=-=-=-=-=-=
{
  ip = null; # e.g. "192.168.1.20" (stable lan address; null = not pinnable)
  hostKey = null; # e.g. "ssh-ed25519 AAAA..." (fkey <hostname>.local; null = dns-only)
  # user = "jar"; # optional: ssh login user on this host (default "jar")
  knows = [ ]; # optional: hosts THIS one pins (default: everyone pinnable; off-lan = [ ])
}
