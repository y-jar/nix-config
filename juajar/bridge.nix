# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: NixOS glue between sysset (system) and usrset (hjem user): the ONLY place they meet.
# -=-=-=-=-=-=-=-=-=-=-=
# =-=-=[bridge.nix] =-=-=
# NixOS-only. The liijar modules never read `osConfig` / `sysset` directly, so the
# user layer can also be evaluated off NixOS (a non-NixOS hjem host just fills
# `usrset.system.*` from its own user.nix, or keeps the defaults).
#
#   system -> user : usrset.system.*  facts the user modules need to know
#   user -> system : sysset.*         toggles that live in user.nix but need a system
#                                     half (nvf module, syncthing service, electron
#                                     permit, dconf/flatpak theme names)
#
# Rule: a value has ONE owner. Do not also set a bridged sysset.* option in a host's
# system.nix (it would conflict); set it in user.nix instead.
# =-=-=[end bridge.nix] =-=-=
{ config, ... }:

let
  mainUser = config.sysset.mainUser;
  u = config.hjem.users.${mainUser};
in
{
  config = {
    # [system -> user] facts read by liijar via config.usrset.system.*
    hjem.users.${mainUser}.usrset.system = {
      platform = "nixos";
      hasDesktop = config.sysset.hasDesktop;
      unfree = config.sysset.nix.unfree.enable;
      nixpkgsYoinks = config.sysset.nix.nixpkgsYoinks.enable;
      mullvad = config.sysset.networking.mullvad.enable;
      audioAddon = config.sysset.audio.addon.enable;
      autostart = config.sysset.autostart.commands;
      webapps = config.sysset.webapps; # browser-apps-as-desktop-apps (sysset.webapps)
      aiModels = config.sysset.ai.ollama.activeModels; # active Ollama model tags
      aiContextLength = config.sysset.ai.ollama.contextLength; # Ollama context window
    };

    # [user -> system] nvf: sysjar/nvf. syncthing: sysjar/syncthing (runs as mainUser).
    sysset.nvf.enable = u.usrset.editors.nvf.enable;
    sysset.syncthing.enable = u.usrset.syncthing.enable;
    # electron-based editors (vscodium/obsidian) pull an EOL insecure electron;
    # surface it so sysjar/nix can permit it only on the hosts that use one.
    sysset.usesElectronEditor = u.usrset.editors.vscodium.enable || u.usrset.editors.obsidian.enable;
    # theming facts so the system side (dconf/flatpak) names the exact theme.
    sysset.theming = {
      enable = u.usrset.theming.enable;
      accent = u.usrset.theming.accent;
      variant = u.usrset.theming.variant;
      gtkThemeName = u.usrset.theming.gtkThemeName;
      iconThemeName = u.usrset.theming.iconThemeName;
    };
  };
}
