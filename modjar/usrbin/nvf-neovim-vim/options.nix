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
          # options
          options = {
            # general settings
            clipboard = "unnamedplus";
            mouse = "a";
            splitbelow = true;
            splitright = true;
            timeoutlen = 500;
            termguicolors = true;
            hidden = true;
            confirm = true;
            completeopt = "menuone,noselect";
            updatetime = 300;

            # tab settings
            tabstop = 2;
            shiftwidth = 2;
            softtabstop = 2;
            expandtab = true;
            shiftround = true;
            autoindent = true;
            smartindent = true;

            # line numbers
            number = true;
            relativenumber = true;
            wrap = false;
            cursorline = true;
            signcolumn = "yes";
            scrolloff = 8;
            sidescrolloff = 5;

            # search
            ignorecase = true;
            smartcase = true;
            incsearch = true;
            hlsearch = true;

            # swap
            swapfile = false;
            backup = false;
            writebackup = false;
            undofile = true;

            # text stuff
            list = true;
            listchars = "tab:→\\ ,trail:°,extends:›,precedes:‹";
            conceallevel = 2;
            concealcursor = "nc";

            # fold yo laundry!
            foldmethod = "indent";
            foldlevel = 99;
            foldenable = false;
          }; # end of vim.options
        }; # end of vim
      }; # end of settings
    }; # end of nvf
  }; # end of config
}
