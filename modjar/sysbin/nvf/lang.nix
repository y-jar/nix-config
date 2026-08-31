{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.sysSettings.nvf.enable {
    programs.nvf = {
      settings = {
        vim = {
          languages = {
            bash.enable = true;
            csharp.enable = true;
            css.enable = true;
            go.enable = true;
            python.enable = true;
            rust.enable = true;
            html.enable = true;
            json.enable = true;
            lua.enable = true;
            markdown.enable = true;
            nix.enable = true;
            yaml.enable = true;
          };

          # Minimal LSP server overrides
          lsp.servers = {
            nil.settings = {
              formatting.command = [ "nixfmt" ];
            };
            pyright.settings = {
              python.analysis.typeCheckingMode = "basic";
            };
            lua-ls.settings = {
              Lua.diagnostics.globals = [ "vim" ];
            };
            rust-analyzer.settings = {
              cargo.buildScripts.enable = true;
            };
            gopls.settings = {
              analyses = {
                unusedparams = true;
              };
              staticcheck = true;
            };
          };
        };
      };
    };
  };
}
