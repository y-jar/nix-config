# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: NVF: dashboard/dash modules.
# -=-=-=-=-=-=-=-=-=-=-=
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
          dashboard.dashboard-nvim = {
            enable = true;
            setupOpts = {
              theme = "doom";
              config = {
                header = [
                  "┌───────────────────────────┐"
                  "│      -=-=-=jar=-=-=-      │"
                  "└───────────────────────────┘"
                ];
                center = [
                  {
                    icon = " ";
                    desc = "Find file";
                    key = "f";
                    action = "Telescope find_files";
                  }
                  {
                    icon = " ";
                    desc = "Live grep";
                    key = "g";
                    action = "Telescope live_grep";
                  }
                  {
                    icon = " ";
                    desc = "File tree";
                    key = "e";
                    action = "NvimTreeToggle";
                  }
                  {
                    icon = " ";
                    desc = "Quit";
                    key = "q";
                    action = "qa";
                  }
                ];
                footer = [ "Tip: press ? for which-key" ];
              }; # end of config
            }; # end of setupOpts
          }; # end of dashboard
        }; # end of vim
      }; # end of settings
    }; # end of nvf
  }; # end of config
}
