# input
{ pkgs, hostnm, ...}:
{
  # import
  imports = [ ]
    ++ (if hostnm == "aari" then [ ./niri-aanri.nix ] else [ ])
    ++ (if hostnm == "calender" then [ ./niri-calender.nix ] else [ ])
    ++ (if hostnm == "cold-flip" then [ ./niri-cold-flip.nix ] else [ ])
    ++ (if hostnm == "chalk-yilene" then [ ./niri-chalk-yilene.nix ] else [ ])
    ++ (if hostnm == "yil-jar" then [ ./niri-yil-jar.nix ] else [ ./niri-base.nix ]);
}
