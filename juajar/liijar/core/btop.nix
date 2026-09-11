# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: btop config (home-manager backend).
# -=-=-=-=-=-=-=-=-=-=-=
{
  ...
}:
{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false; # make btop transparent
    };
  };
}
