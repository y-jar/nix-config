{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.hjmSettings.nvf.enable {
    programs.nvf = {
      settings = {
        vim = {
          filetree.nvimTree = {
            enable = true;
            setupOpts = {
              view = {
                width = 30;
                side = "right";
              };

              renderer = {
                group_empty = true;
                indent_markers.enable = true;
              };

              filters = {
                dotfiles = false;
                git_ignored = true;
              };

              git.enable = true;

              update_focused_file = {
                enable = true;
                update_root = true;
              };
            };
          };
        };
      };
    };
  };
}
