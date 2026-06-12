{ inputs, ... }:

{
  imports = [
    inputs.nvf.homeManagerModules.default # nixvim inputs
  ];

  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;

        autocomplete.nvim-cmp.enable = true;
        filetree.neo-tree.enable = true;
        autopairs.nvim-autopairs.enable = true;

        theme = {
          name = "gruvbox";
          enable = true;
          style = "dark";
          transparent = true;
        };
        lsp = {
          enable = true;
        }; # end of vim.lsp
        statusline = {
          lualine.enable = true;
        }; # end of vim.statusline
        telescope = {
          enable = true;
        }; # end of vim.telescope
        treesitter = {
          enable = true;
          addDefaultGrammars = true;
        }; # end of vim.treesitter

        # ==============[KEYBINDINGS]
        keymaps = [
          {
            key = "<leader>m";
            mode = "n";
            silent = true;
            action = ":make<CR>";
          }
          {
            key = "<leader>l";
            mode = [
              "n"
              "x"
            ];
            silent = true;
            action = "<cmd>cnext<CR>";
          }
        ];
      }; # end of vim
    }; # end of settings
  }; # end of nvf
}
