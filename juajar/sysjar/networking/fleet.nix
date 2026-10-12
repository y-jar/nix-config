# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Fleet identity pins: dns names + pinned ssh host keys from every host's net.nix.
# -=-=-=-=-=-=-=-=-=-=-=
# [fleet phone book] every hstjar/<host>/net.nix is pure data:
#   ip / hostKey = identity (single source of truth per host)
#   user         = optional ssh login user on that host (default sysset.networking.fleet.defaultUser)
#   knows        = optional list of hosts THIS one pins
# Entries with a real ip are pinnable; hostKey = null means dns-only. Host configs
# cannot see each other, but this shared data read (fleetDir, from mkJar) can.
{
  hostnm,
  fleetDir,
  config,
  lib,
  ...
}:
let
  cfg = config.sysset.networking.fleet;

  fleetRaw = lib.filterAttrs (
    name: type: type == "directory" && builtins.pathExists (fleetDir + "/${name}/net.nix")
  ) (builtins.readDir fleetDir);
  fleet = lib.filterAttrs (_: data: data ? ip && data.ip != null) (
    lib.mapAttrs (name: _: import (fleetDir + "/${name}/net.nix")) fleetRaw
  );

  # [who i know] this host's own net.nix may declare `knows`: the fleet hosts it
  # pins (dns + ssh). Hosts without a list know everyone pinnable (flexible by
  # default); off-lan hosts opt out with knows = [ ].
  myData =
    if builtins.pathExists (fleetDir + "/${hostnm}/net.nix") then
      import (fleetDir + "/${hostnm}/net.nix")
    else
      { };
  myKnows = if myData ? knows && myData.knows != null then myData.knows else builtins.attrNames fleet;

  # [applied pins] a host always knows itself; plus everyone in its list.
  known = lib.filterAttrs (name: _: name == hostnm || builtins.elem name myKnows) fleet;

  # hosts with a pinned key get the full treatment (dns pin + known_hosts + ssh
  # block); hosts with hostKey = null only get the dns pin.
  pinned = lib.filterAttrs (_: data: data ? hostKey && data.hostKey != null) known;
in
{
  options.sysset.networking.fleet = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Pin the fleet: /etc/hosts names, ssh known_hosts and per-host ssh blocks from hstjar/*/net.nix.";
    };
    defaultUser = lib.mkOption {
      type = lib.types.str;
      default = "jar";
      description = "ssh login user for fleet hosts whose net.nix has no `user`.";
    };
  };

  config = lib.mkIf cfg.enable {
    # a `knows` entry with no pinnable net.nix is a typo or an off-lan host:
    # fail the build naming it instead of silently pinning nothing
    assertions = [
      {
        assertion = lib.all (n: builtins.hasAttr n fleet) myKnows;
        message = "networking.fleet: ${hostnm}'s net.nix knows a host with no pinnable net.nix (missing hstjar/<name>/net.nix or ip = null): ${
          toString (lib.filter (n: !builtins.hasAttr n fleet) myKnows)
        }";
      }
    ];

    # [fleet pins] one line per known host: dns resolves without avahi. ips are
    # stable dhcp-reserved lan addresses
    networking.extraHosts = lib.concatStringsSep "\n" (
      lib.mapAttrsToList (name: data: "${data.ip} ${name} ${name}.local") known
    );

    # [fleet ssh] pinned host keys + per-host blocks. UserKnownHostsFile points
    # fleet hosts at the global pinned file only: the user's ~/.ssh/known_hosts is
    # bypassed (stale entries can't break logins or trigger warnings).
    programs.ssh = {
      knownHosts = lib.mapAttrs (name: data: {
        hostNames = [
          name
          "${name}.local"
          data.ip
        ];
        publicKey = data.hostKey;
      }) pinned;
      extraConfig = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (name: data: ''
          Host ${name} ${name}.local ${data.ip}
            HostName ${name}.local
            User ${data.user or cfg.defaultUser}
            UserKnownHostsFile /etc/ssh/ssh_known_hosts
        '') pinned
      );
    }; # end of programs.ssh
  };
}
