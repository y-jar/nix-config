# espanso text expander — shared trigger/replacement config.
# Consumed by host home.nix / hjem.nix:
#   espanso = (import ../espansoconf.nix { });                     # enabled (default)
#   espanso = (import ../espansoconf.nix { enable = false; });     # headless / template hosts
{
  enable ? true,
}:
{
  inherit enable;
  shorts = {
    ":addr" = "123 Jar Street, Warrington";
    ":sign" = "Always Learning,\nJar / Park";
    ":np" = "now playing: $|$";
    ":gitadd" = "git add -A && git commit -m \"$|$\"";
    ":date" = "{{mydate}}";
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
