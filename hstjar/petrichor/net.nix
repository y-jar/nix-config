# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3>
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Host petrichor: fleet identity (kway's machine - never on my lan).
# -=-=-=-=-=-=-=-=-=-=-=
# NOTE (IMPORTANT): this file is PURE DATA, not a module - the networking
# module (juajar/sysjar/networking) imports every hstjar/*/net.nix as a
# phone book entry. this host is OFF-LAN by design: ip/hostKey stay null
# (nobody can pin it) and knows = [ ] (it pins nobody), so petrichor keeps
# plain default ssh behavior wherever it actually lives. user = "kway"
# documents its login user for if it ever gets a reachable address.
# -=-=-=-=-=-=-=-=-=-=-=
{
  ip = null; # never on my lan - not pinnable
  hostKey = null; # only fill (via fkey) if it ever becomes reachable
  user = "kway"; # ssh login user on this host
  knows = [ ]; # pins nobody (off-lan)
}
