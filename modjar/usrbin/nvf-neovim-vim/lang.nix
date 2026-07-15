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
          languages = {
            bash = {
              enable = true;
              lsp.servers.bashls = { };
              treesitter.enable = true;
            };
            csharp = {
              enable = true;
              treesitter.enable = true;
            };
            css = {
              enable = true;
              lsp.servers.cssls = { };
              treesitter.enable = true;
            };
            go = {
              enable = true;
              lsp.servers.gopls = {
                settings = {
                  analyses = { unusedparams = true; };
                  staticcheck = true;
                };
              };
              treesitter.enable = true;
            };
            python = {
              enable = true;
              lsp.servers.pyright = {
                settings = {
                  python.analysis.typeCheckingMode = "basic";
                };
              };
              treesitter.enable = true;
            };
            rust = {
              enable = true;
              lsp.servers.rust-analyzer = {
                settings = {
                  cargo.buildScripts.enable = true;
                  procMacro.enable = true;
                };
              };
              treesitter.enable = true;
            };
            html = {
              enable = true;
              treesitter.enable = true;
            };
            json = {
              enable = true;
              lsp.servers.jsonls = { };
              treesitter.enable = true;
            };
            lua = {
              enable = true;
              lsp.servers.lua-ls = {
                settings = {
                  Lua = {
                    diagnostics.globals = [ "vim" ];
                    workspace.checkThirdParty = false;
                  };
                };
              };
              treesitter.enable = true;
            };
            markdown = {
              enable = true;
              treesitter.enable = true;
            };
            nix = {
              enable = true;
              lsp.servers.nil = {
                settings = {
                  formatting.command = [ "nixfmt" ];
                };
              };
              treesitter.enable = true;
            };
            yaml = {
              enable = true;
              lsp.servers.yamlls = { };
              treesitter.enable = true;
            };
          }; # end of languages
        }; # end of vim
      }; # end of settings
    }; # end of nvf
  }; # end of config
}
