# input
{ pkgs, hostnm, ...}:
{
  # import
  imports = [ ]
    ++ (if hostnm == "aanri" then [ ./niri-aanri.nix ] else [])
    ++ (if hostnm == "calender" then [ ./niri-calender.nix ] else [])
    ++ (if hostnm == "flipped-shark" then [ ./niri-flipped-shark.nix ] else [])
    ++ (if hostnm == "tyun" then [ ./niri-tyun.nix ] else [])
    ++ (if hostnm == "yilyonix" then [ ./niri-yilyonix.nix ] else [])
    # base is only loaded if no host-specific config matched above
    ++ (if builtins.elem hostnm [ "aanri" "calender" "flipped-shark" "tyun" "yilyonix" ]
        then [] else [ ./niri-base.nix ]);
}
