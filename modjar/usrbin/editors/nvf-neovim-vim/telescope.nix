{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.usrSettings.editors.nvf.enable {
    programs.nvf = {
      settings = {
        vim = {
          telescope = {
            enable = true;
            extensions = [
              {
                name = "fzf";
                packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
                setup = {
                  fzf = {
                    fuzzy = true;
                    override_file_sorter = true;
                    override_generic_sorter = true;
                    case_mode = "smart_case";
                  }; # end of fzf
                }; # end of setup
              } # end of fzf
            ];
            setupOpts = {
              defaults = {
                layout_config.horizontal.prompt_position = "top";
                sorting_strategy = "ascending";
              }; # end of defaults
              pickers.find_files.hidden = true;
            }; # end of setupOpts
          }; # end of telescope
        }; # end of vim
      }; # end of settings
    }; # end of nvf
  }; # end of config
}
