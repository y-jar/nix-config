{ config, lib, ... }:

{
  options = {
    usrSettings.name = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Git user name";
    };
    usrSettings.email = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Git user email";
    };
  };
}
