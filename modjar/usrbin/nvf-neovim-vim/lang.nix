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
          }; # end of languages
        }; # end of vim
      }; # end of settings
    }; # end of nvf
  }; # end of config
}
