# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Shared espanso triggers/replacements consumed by host user.nix.
# -=-=-=-=-=-=-=-=-=-=-=
# espanso text expander shared trigger/replacement config.
# Consumed by host user.nix:
#   espanso = (import ../../juajar/data/espansoconf.nix { });                     # enabled (default)
#   espanso = (import ../../juajar/data/espansoconf.nix { enable = false; });     # headless / template hosts
{
  enable ? true,
}:
{
  inherit enable;
  shorts = {
    ":jaddr" = "123 Jar Street, Warrington";
    ":jsign" = "Always Learning,\nJar / Park";
    ":jnp" = "now playing: $|$";
    ":jgitadd" = "git add -A && git commit -m \"$|$\"";
    ":jdate" = "{{mydate}}";
    ":jart" = ''
      ╃
       .▀▀█▀▀ .
         :▓.:
      . ▀▀ : ╃
    '';
  };
  vars = [
    {
      name = "mydate";
      type = "date";
      params = {
        format = "%Y-%m-%d";
      };
    }
  ];
}
