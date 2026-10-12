# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Shared WM helpers (host-inputs lookup) used by every WMs/<wm>/user.nix.
# -=-=-=-=-=-=-=-=-=-=-=
# Not a module: `import ../lib.nix` returns an attrset of functions.
#
#   hostInput { dir, host, ext }
#     -> <dir>/host-inputs/<host>.<ext> when it exists, else
#        <dir>/host-inputs/0-unknown.<ext> (the safe fallback every WM ships).
{
  hostInput =
    {
      dir,
      host,
      ext,
    }:
    let
      specific = dir + "/host-inputs/${host}.${ext}";
    in
    if builtins.pathExists specific then specific else dir + "/host-inputs/0-unknown.${ext}";
}
