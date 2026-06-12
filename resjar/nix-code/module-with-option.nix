{
  config,
  lib,
  ...
}:
let
  cfg = config.MAIN.OPTION.SUBOPTION;
in
{
  options = {
    MAIN.OPTION.SUBOPTION = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  }; # end of options

  config = lib.mkIf cfg.enable {
    # PLACEHOLDER
  };
}
