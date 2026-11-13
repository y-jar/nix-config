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
{ config, lib, ... }:

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
      # Guard the read-only option: it is only defined when Ollama is enabled.
      aiModels =
        if config.sysset.ai.enable && config.sysset.ai.ollama.enable then
          config.sysset.ai.ollama.activeModels
        else
          [ ];
      aiContextLength = config.sysset.ai.ollama.contextLength; # Ollama context window
      # Per-model definitions: nickname -> { alias, source, num_ctx, display, target }.
      # liijar/ai/opencode.nix uses these for the main provider and limits.
      aiModelDefs = lib.mapAttrs (name: model: {
        alias = name;
        inherit (model) source num_ctx target;
        display = if model.display != null then model.display else name;
      }) config.sysset.ai.ollama.models;
      aiSmallModel = config.sysset.ai.ollama.smallModel;
      aiMainModel = config.sysset.ai.ollama.mainModel;
      aiCpuPort = config.sysset.ai.ollama.cpu.port;
    };

    # [user -> system] nvf: sysjar/nvf. syncthing: sysjar/syncthing (runs as mainUser).
    sysset.nvf.enable = u.usrset.editors.nvf.enable;
    sysset.syncthing.enable = u.usrset.syncthing.enable;
    # tablet driver: any declared tablet on the OTD driver turns the system half on
    sysset.opentabletdriver.enable = lib.any (t: t.enable && t.driver == "opentabletdriver") (
      lib.attrValues u.usrset.tablets
    );
    # Hermes: the user toggle drives the system-side config seed.
    sysset.ai.hermes.enable = u.usrset.ai.hermes.enable;
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
