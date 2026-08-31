# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: nvf wiring (system-level: hjem hosts have no programs.nvf at user scope).
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  ...
}:
let
  cfg = config.sysSettings.nvf;
  keymaps = import ./keybinds.nix;
in
{
  imports = [
    ./telescope.nix
    ./lang.nix
    ./git.nix
    ./filetree.nix
    ./dash.nix
    ./options.nix
  ];

  options = {
    sysSettings.nvf.enable = lib.mkEnableOption "nvf (neovim config) for hjem hosts";
  };

  config = lib.mkIf config.sysSettings.nvf.enable {
    programs.nvf = {
      enable = true;

      settings = {
        vim = {
          viAlias = false;
          vimAlias = true;
          globals.mapleader = " ";

          # plugins
          autocomplete.nvim-cmp.enable = true;
          autopairs.nvim-autopairs.enable = true;
          comments.comment-nvim.enable = true;
          utility.surround.enable = true;

          # extra plugins
          startPlugins = [
            "image-nvim"
            "nui-nvim"
            "nvim-web-devicons"
            "render-markdown-nvim"
          ];

          # basic bindings
          inherit keymaps;
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
          };

          # [theme]
          theme = {
            name = "gruvbox";
            enable = true;
            style = "dark";
            transparent = true;
          };

          # [lsp]
          lsp = {
            enable = true;
          };

          # [statusline]
          statusline = {
            lualine.enable = true;
          };

          # [treesitter]
          treesitter = {
            enable = true;
            addDefaultGrammars = true;
          };

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
        };
      };
    };
  };
}
