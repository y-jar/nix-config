# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3>
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host template: fleet identity (ssh + dns pins, applied to every host).
# -=-=-=-=-=-=-=-=-=-=-=
# NOTE (IMPORTANT): this file is PURE DATA, not a module - the networking
# module (juajar/sysjar/networking) imports every hstjar/*/net.nix so all
# hosts pin each other's ip (/etc/hosts) + ssh host key
# (/etc/ssh/ssh_known_hosts).
# -=-=-=-=-=-=-=-=-=-=-=
# fill these in once the host is online (scan the key with the `fkey`
# alias), or leave them null to keep this host out of the fleet pins
# until then.
# -=-=-=-=-=-=-=-=-=-=-=
{
  ip = null; # e.g. "192.168.1.20" (stable lan address)
  hostKey = null; # e.g. "ssh-ed25519 AAAA..." (fkey <hostname>.local)
}
