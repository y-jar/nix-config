# input
{ pkgs, hostnm, ...}:
{
  # import
  imports = [ ]
    ++ (if hostnm == "aari" then [ ./niri-aanri.nix ] else [ ])
    ++ (if hostnm == "calender" then [ ./niri-calender.nix ] else [ ])
    ++ (if hostnm == "cold-flip" then [ ./niri-cold-flip.nix ] else [ ])
    ++ (if hostnm == "tyun" then [ ./niri-tyun.nix ] else [ ])
    ++ (if hostnm == "yilyonix" then [ ./niri-yilyonix.nix ] else [ ./niri-base.nix ]);
}
