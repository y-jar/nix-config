# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: shared webapp slug helper (sysjar + liijar webapps must stay identical).
# -=-=-=-=-=-=-=-=-=-=-=
{ lib }:
name:
lib.toLower (
  builtins.replaceStrings
    [
      " "
      "."
      "/"
      "_"
      "("
      ")"
      "'"
      "&"
      ":"
    ]
    [
      "-"
      "-"
      "-"
      "-"
      "-"
      "-"
      "-"
      "-"
      "-"
    ]
    name
)
