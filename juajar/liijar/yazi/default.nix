# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: yazi: yazi TOML dotfiles generation + the yazi package.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.usrset.yazi;

  yaziPackages = [ pkgs.yazi ]; # end of yaziPackages

  # =-=-=[theme.toml] =-=-=
  # The theme is provided by the gruvbox-dark flavor (current yazi schema);
  # theme.toml only references it. Yazi merges the flavor automatically and
  # supplies default icons + filetype highlighting (no hand-maintained schema
  # here to drift).
  themeToml = pkgs.writeText "theme.toml" ''
    [flavor]
    dark  = "gruvbox-dark"
    light = "gruvbox-dark"
  '';

  # =-=-=[yazi.toml] =-=-=
  yaziToml = pkgs.writeText "yazi.toml" ''
    [[open.rules]]
    url = "*.md"
    use = "edit"

    [[open.rules]]
    mime = "text/*"
    use = "edit"

    [[open.rules]]
    url = "*.json"
    use = "edit"

    [[open.rules]]
    url = "*.kdl"
    use = "edit"

    [[open.rules]]
    url = "*.nix"
    use = "edit"

    [[open.rules]]
    url = "*.rs"
    use = "edit"

    [[opener.edit]]
    block = true
    desc = "Open in Neovim"
    run = "nvim \"$@\""
  '';

  # =-=-=[keymap.toml] =-=-=
  keymapToml = pkgs.writeText "keymap.toml" ''
    [[manager.prepend_keymap]]
    desc = "Go to projects"
    on = ["g", "p"]
    run = "cd ~/Projects"

    [[manager.prepend_keymap]]
    desc = "Go to screenshots"
    on = ["g", "s"]
    run = "cd ~/Screenshots"

    [[manager.prepend_keymap]]
    on = ["@"]
    run = "shell ' \"$@\"' --cursor=0 --interactive"

    [[manager.prepend_keymap]]
    on = ["<C-h>"]
    run = "hidden toggle"

    [[manager.prepend_keymap]]
    on = ["y", "y"]
    run = "yank"

    [[manager.prepend_keymap]]
    on = ["y", "p"]
    run = "copy path"

    [[manager.prepend_keymap]]
    on = ["y", "d"]
    run = "copy dirname"

    [[manager.prepend_keymap]]
    on = ["y", "n"]
    run = "copy filename"

    [[manager.prepend_keymap]]
    on = ["y", "N"]
    run = "copy name_without_ext"

    [[manager.prepend_keymap]]
    on = ["d", "d"]
    run = "yank --cut"

    [[manager.prepend_keymap]]
    on = ["d", "D"]
    run = "remove --force"

    [[manager.prepend_keymap]]
    on = ["p", "p"]
    run = "paste"

    [[manager.prepend_keymap]]
    on = ["p", "P"]
    run = "paste --force"

    [[manager.prepend_keymap]]
    on = ["c", "d"]
    run = "cd --interactive"

    [[manager.prepend_keymap]]
    on = ["o", "m"]
    run = "sort mtime --reverse=no"

    [[manager.prepend_keymap]]
    on = ["o", "M"]
    run = "sort mtime --reverse=yes"

    [[manager.prepend_keymap]]
    on = ["o", "b"]
    run = "sort natural --reverse=no"

    [[manager.prepend_keymap]]
    on = ["o", "B"]
    run = "sort natural --reverse=yes"

    [[manager.prepend_keymap]]
    on = ["o", "a"]
    run = "sort alphabetical --reverse=no"

    [[manager.prepend_keymap]]
    on = ["o", "A"]
    run = "sort alphabetical --reverse=yes"

    [[manager.prepend_keymap]]
    on = ["o", "e"]
    run = "sort extension --reverse=no"

    [[manager.prepend_keymap]]
    on = ["o", "E"]
    run = "sort extension --reverse=yes"

    [[manager.prepend_keymap]]
    on = ["o", "s"]
    run = "sort size --reverse=no"

    [[manager.prepend_keymap]]
    on = ["o", "S"]
    run = "sort size --reverse=yes"

    [[manager.prepend_keymap]]
    on = ["t"]
    run = "tab_create --current"

    [[manager.prepend_keymap]]
    on = ["x"]
    run = "close"

    [[manager.prepend_keymap]]
    on = ["J"]
    run = "tab_switch 1 --relative"

    [[manager.prepend_keymap]]
    on = ["<C-Tab>"]
    run = "tab_switch 1 --relative"

    [[manager.prepend_keymap]]
    on = ["K"]
    run = "tab_switch -1 --relative"

    [[manager.prepend_keymap]]
    on = ["<C-BackTab>"]
    run = "tab_switch -1 --relative"

    [[manager.prepend_keymap]]
    on = ["u"]
    run = "undo"

    [[manager.prepend_keymap]]
    on = ["<C-r>"]
    run = "redo"
  '';

in
{
  config = lib.mkIf cfg.enable {
    files = {
      ".config/yazi/yazi.toml".source = yaziToml;
      ".config/yazi/keymap.toml".source = keymapToml;
      ".config/yazi/theme.toml".source = themeToml;
      # gruvbox-dark flavor (provides all styling; theme.toml just references it)
      ".config/yazi/flavors/gruvbox-dark.yazi".source = inputs.gruvbox-dark-yazi;
    };
    packages = yaziPackages;
  };
}
