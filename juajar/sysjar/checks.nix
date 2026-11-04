# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Cross-module sanity assertions (no options, no config besides assertions).
# -=-=-=-=-=-=-=-=-=-=-=
# A check that only concerns ONE module lives in that module. Checks that compare
# two or more modules (so neither owns them) live here: desktop exclusivity, port
# clashes between services, a service that needs another one.
{ config, lib, ... }:
let
  s = config.sysset;

  # [desktop environments] one DE per host (compositors like niri/mango/hyprland
  # may sit next to one DE, they are not DEs)
  desktops = lib.filterAttrs (_: enabled: enabled) {
    gnome = s.gnome.enable;
    cosmic = s.cosmic.enable;
    cinnamon = s.cinnamon.enable;
  };

  # [service ports] every enabled service that binds a fixed port on the host
  services = [
    {
      name = "komga";
      enable = s.server.komga.enable;
      port = 25600;
    }
    {
      name = "jellyfin";
      enable = s.server.jellyfin.enable;
      port = 8096;
    }
    {
      name = "nixdraw";
      enable = s.server.nixdraw.enable;
      port = s.server.nixdraw.port;
    }
    {
      name = "outline";
      enable = s.server.outline.enable;
      port = s.server.outline.port;
    }
    {
      name = "authentik";
      enable = s.server.authentik.enable;
      port = s.server.authentik.port;
    }
    {
      name = "webjar";
      enable = s.server.webjar.enable;
      port = s.server.webjar.port;
    }
    {
      name = "cockpit";
      enable = s.server.cockpit.enable;
      port = s.server.cockpit.port;
    }
    {
      name = "ai (llama.cpp)";
      enable = s.ai.enable && s.ai.llama.enable;
      port = s.ai.port;
    }
    {
      name = "ai (ollama)";
      enable = s.ai.enable && s.ai.ollama.enable;
      port = s.ai.port;
    }
    {
      name = "ai (ollama-cpu)";
      enable = s.ai.enable && s.ai.ollama.enable && s.ai.ollama.cpu.enable;
      port = s.ai.ollama.cpu.port;
    }
    {
      name = "ai (open webui)";
      enable = s.ai.enable && s.ai.webui.enable;
      port = s.ai.webui.port;
    }
  ];
  active = lib.filter (x: x.enable) services;
  clashes = lib.filterAttrs (_: names: lib.length names > 1) (
    lib.groupBy' (acc: x: acc ++ [ x.name ]) [ ] (x: toString x.port) active
  );

  # [ai models] aliases, nicknames, and the measured VRAM budget.
  ai = s.ai.ollama;
  validModelRef =
    m:
    builtins.match "hf\\.co/[^/]+/[^:]+(:.+)?$" m != null
    || builtins.match "[a-zA-Z0-9._-]+(:[a-zA-Z0-9._-]+)?" m != null;
  validNickname = n: builtins.match "[a-z0-9][a-z0-9._-]*" n != null;
  modelNames = lib.attrNames ai.models;
  displayNames = lib.mapAttrsToList (n: m: if m.display != null then m.display else n) ai.models;
  gpuModels = lib.filterAttrs (_: m: m.target == "gpu") ai.models;
  gpuModelNames = lib.attrNames gpuModels;
  hasFootprint = m: m.weightsMB != null && m.kvMBPer1k != null;
  withinBudget =
    m:
    (m.weightsMB + m.kvFixedMB + builtins.div (m.num_ctx + 999) 1000 * m.kvMBPer1k) <= ai.vramBudgetMB;
  overBudget = builtins.filter (
    n: hasFootprint gpuModels.${n} && !(withinBudget gpuModels.${n})
  ) gpuModelNames;
  modelSourceList = lib.mapAttrsToList (_: m: m.source) ai.models;
  badRefs = builtins.filter (m: !(validModelRef m)) modelSourceList;
  badNames = builtins.filter (n: !(validNickname n)) modelNames;
  sourceCollisions = builtins.filter (n: builtins.elem n modelSourceList) modelNames;
  cpuModels = lib.filterAttrs (_: m: m.target == "cpu") ai.models;
  resolves =
    ref:
    ref == null
    || builtins.hasAttr ref ai.models
    || builtins.elem ref ai.activeModels
    || builtins.any (m: m.source == ref) (lib.attrValues ai.models);
in
{
  assertions = [
    {
      assertion = lib.length (lib.attrNames desktops) <= 1;
      message = "only one desktop environment per host, but these are enabled: ${toString (lib.attrNames desktops)}";
    }
    {
      assertion = clashes == { };
      message = "two services want the same port: ${
        lib.concatStringsSep "; " (lib.mapAttrsToList (port: names: "${port} <- ${toString names}") clashes)
      }";
    }
    {
      assertion = !(s.ai.enable && s.ai.webui.enable) || (s.ai.llama.enable || s.ai.ollama.enable);
      message = "sysset.ai.webui needs a local AI backend: set sysset.ai.llama.enable or sysset.ai.ollama.enable = true.";
    }
    {
      assertion = !(s.ai.llama.enable && s.ai.ollama.enable);
      message = "sysset.ai: enable only one of llama or ollama at a time.";
    }
    {
      assertion =
        let
          u = config.hjem.users.${config.sysset.mainUser}.usrset.gaming;
        in
        !(u.protonplus.enable && !s.gaming.steam.enable && !u.heroic.enable);
      message = "usrset.gaming.protonplus needs a managed launcher: enable sysset.gaming.steam (system.nix) or usrset.gaming.heroic (user.nix).";
    }
    {
      assertion =
        !(s.ai.enable && s.ai.ollama.enable && s.ai.ollama.kvCache != "f16") || s.ai.ollama.flashAttention;
      message = "sysset.ai.ollama.kvCache (${s.ai.ollama.kvCache}) requires flashAttention = true.";
    }
  ]
  ++ lib.optionals (s.ai.enable && s.ai.ollama.enable) [
    {
      assertion = ai.modelSet == "custom" -> ai.models != { };
      message = "sysset.ai.ollama.modelSet is \"custom\" but models is empty.";
    }
    {
      assertion = ai.modelSet != "custom" -> ai.models == { };
      message = "sysset.ai.ollama.models is set but modelSet = \"${ai.modelSet}\"; set modelSet = \"custom\" to use it.";
    }
    {
      assertion = badRefs == [ ];
      message = "Invalid Ollama model source(s): ${lib.concatStringsSep ", " badRefs}. Use name:tag or hf.co/org/repo:QUANT.";
    }
    {
      assertion = badNames == [ ];
      message = "Invalid models nickname(s): ${lib.concatStringsSep ", " badNames}. Use [a-z0-9][a-z0-9._-]*.";
    }
    {
      assertion = sourceCollisions == [ ];
      message = "models nickname collides with a source tag: ${lib.concatStringsSep ", " sourceCollisions}.";
    }
    {
      assertion = lib.length displayNames == lib.length (lib.unique displayNames);
      message = "Duplicate models display names: ${lib.concatStringsSep ", " displayNames}.";
    }
    {
      assertion = ai.cpu.enable || lib.length (lib.attrNames cpuModels) == 0;
      message = "models has target=\"cpu\" but sysset.ai.ollama.cpu.enable = false.";
    }
    {
      assertion = overBudget == [ ];
      message = "VRAM budget (${toString ai.vramBudgetMB}MB) exceeded for model(s): ${lib.concatStringsSep ", " overBudget}.";
    }
    {
      assertion = ai.models == { } || !ai.syncModels;
      message = "sysset.ai.ollama.syncModels = true would prune the generated aliases; set it to false when using `models`.";
    }
    {
      assertion = resolves ai.smallModel;
      message = "sysset.ai.ollama.smallModel is not a nickname, active model, or model source.";
    }
    {
      assertion = resolves ai.mainModel;
      message = "sysset.ai.ollama.mainModel is not a nickname, active model, or model source.";
    }
    {
      assertion = ai.smallModel == null || ai.mainModel == null || ai.smallModel != ai.mainModel;
      message = "sysset.ai.ollama.smallModel and mainModel must differ.";
    }
  ];
}
