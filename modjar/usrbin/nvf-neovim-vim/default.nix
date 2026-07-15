{
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.usrSettings.editors.nvf;
  keymaps = import ./keybinds.nix;
in
{
  imports = [
    inputs.nvf.homeManagerModules.default # nixvim inputs
    ./telescope.nix # telescope config
    ./lang.nix # language config
    ./git.nix # git config
    ./filetree.nix # filetree config
    ./dash.nix # dashboard config
    ./options.nix # vim options
  ];

  options = {
    usrSettings.editors.nvf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Enable nvf (neovim-config)";
      }; # end of enable
    }; # end of usrSettings.editors.nvf
  }; # end of options

  config = lib.mkIf cfg.enable {
    # set def app
    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    programs.nvf = {
      enable = true;

      # settings for nvf
      settings = {

        # vim settings
        vim = {
          viAlias = false;
          vimAlias = true;
          globals.mapleader = " ";

          # plugins
          autocomplete.nvim-cmp.enable = true;
          autopairs.nvim-autopairs.enable = true;
          comments.comment-nvim.enable = true;
          utility.surround.enable = true;

          # basic bindings
          inherit keymaps; # add dem mappings!
          binds.whichKey = {
            enable = true;
            register = {
              "<leader>e" = "+Explorer";
              "<leader>f" = "+Find/Telescope";
              "<leader>b" = "+Buffer";
              "<leader>w" = "+Window";
              "<leader>g" = "+Git";
              "<leader>l" = "+Language";
              "<leader>x" = "+Diagnostics";
            };
          }; # end of binds.whichKey

          # [theme]
          theme = {
            name = "gruvbox";
            enable = true;
            style = "dark";
            transparent = true;
          }; # end of vim.theme

          # [lsp]
          lsp = {
            enable = true;
          }; # end of vim.lsp

          # [statusline]
          statusline = {
            lualine.enable = true;
            # theme = "auto";
            # sectionSeparator = {
            #   left = ">";
            #   right = "<";
            # };
            # componentSeparator = {
            #   left = "{";
            #   right = "}";
            # };
          }; # end of vim.statusline

          # [treesitter]
          treesitter = {
            enable = true;
            addDefaultGrammars = true;
          }; # end of vim.treesitter

          # [luaConfigRC]
          luaConfigRC.example = ''
            vim.api.nvim_create_autocmd("TextYankPost", {
              callback = function()
                vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
              end,
            })

            vim.api.nvim_create_autocmd("FileType", {
              pattern = "markdown",
              callback = function()
                vim.opt_local.wrap = true
                vim.opt_local.linebreak = true
                vim.opt_local.spell = true
              end,
            })

            -- Resize splits if window got resized
            vim.api.nvim_create_autocmd("VimResized", {
              callback = function()
                vim.cmd("tabdo wincmd =")
              end,
            })

            -- Return to last edit position when opening files
            vim.api.nvim_create_autocmd("BufReadPost", {
              callback = function()
                local mark = vim.api.nvim_buf_get_mark(0, '"')
                local lcount = vim.api.nvim_buf_line_count(0)
                if mark[1] > 0 and mark[1] <= lcount then
                  pcall(vim.api.nvim_win_set_cursor, 0, mark)
                end
              end,
            })
          '';
        }; # end of vim
      }; # end of settings
    }; # end of nvf
  }; # end of config
}
