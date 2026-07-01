{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.usrSettings.editors.nvf.enable {
    programs.nvf = {
      settings = {
        vim = {
          filetree.nvimTree = {
            enable = true;
            setupOpts = {
              view = {
                width = 30;
                side = "right";
              }; # end of view

              renderer = {
                group_empty = true;
                indent_markers.enable = true;
              }; # end of renderer

              filters = {
                dotfiles = false;
                git_ignored = true;
              }; # end of filters

              git.enable = true;

              update_focused_file = {
                enable = true;
                update_root = true;
              }; # end of update_focused_file
            }; # end of setupOpts
          }; # end of nvimTree
        }; # end of vim
      }; # end of settings
    }; # end of nvf
  }; # end of config
}
