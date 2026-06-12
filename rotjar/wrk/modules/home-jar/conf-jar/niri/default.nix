{ hostnm, ... }:
{
  xdg.configFile = {
    "niri/config.kdl".source = ./config.kdl; # base linker
    # global
    "niri/bindings.kdl".source = ./bindings.kdl;
    "niri/base.kdl".source = ./base.kdl;
    "niri/rules.kdl".source = ./rules.kdl;
    "niri/startups.kdl".source = ./startups.kdl;
    # host specific
    "niri/host-inputs.kdl".source = ./host-specific-inputs-bin/${hostnm}.kdl;
  };
}
