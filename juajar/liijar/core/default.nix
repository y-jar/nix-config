# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: Core always-on user packages + btop config.
# -=-=-=-=-=-=-=-=-=-=-=
# Union of the old hjem core bucket + the old home-manager bucket, plus the
# btop config (converted from the old home-manager programs.btop). Wine is
# opt-in (usrset.wine.enable, ~500MiB).
{
  config,
  lib,
  pkgs,
  osConfig,
  inputs,
  ...
}:
let
  cfg = config.usrset;
in
{
  config = lib.mkMerge [
    {
      packages =
        with pkgs;
        [
          # =======[core shell]
          zsh

          # =======[cli tools]
          ripgrep # fast recursive grep (better than grep -r)
          fd # Simple, fast and user-friendly alternative to find
          bat # Cat(1) clone with syntax highlighting and Git integration
          fzf # fuzzy finder
          zoxide # smarter cd
          jq # Lightweight and flexible command-line JSON processor [needed for my jsearch script]
          noogle-search # search Nix functions from the CLI

          # =======[ness jar]
          lynx # text-based web browser
          popsicle # iso burner
          caligula # image burner in the cl
          gnome-disk-utility # Udisks graphical front-end

          # =======[dev jar]
          tldr # Simplified and community-driven man pages
          jp # json parser
          tree # Command to produce a depth indented listing of files
          # (cowsay lives in liijar/cowsay the commented reference example module)

          # =======[nix jar]
          nix-output-monitor # prettier nix build output (nom)
          nix-tree # visualize nix dependency tree
          nurl # fetch a URL and output a nix hash
          nix-init # generate a nix package from a repo URL

          # =======[cli jar]
          gum # interactive CLI prompts, confirmations, choosers
          lla # modern ls with icons, plugins, gitignore
          sd # sed alternative, intuitive find-and-replace
          trash-cli # safe rm to trash instead of permanent delete
          chafa # terminal image/file viewer with sixel/kitty support
          cliamp # CLI music player
        ]
        # wine is opt-in (usrset.wine.enable) pulls wine-gecko + wine-mono too
        ++ lib.optionals cfg.wine.enable [
          wine # Wine is a compatibility layer for running Windows programs on Unix-like systems
        ]
        ++ lib.optionals (osConfig.sysset.UseNixPkgsYoinks.enable or false) [
          inputs.rsakura.packages.x86_64-linux.default # a cool thing whisper did, awesone of them to add it as a pkgs in nix! ref: https://github.com/preprocessor/rsakura
        ];
    }
    {
      # [btop] transparent background (converted from the old home-manager
      # programs.btop). NOTE: hjem symlinks this read-only, so btop can't
      # self-save settings runtime changes vanish on restart (same tradeoff
      # as mpv/yazi configs on hjem hosts).
      packages = [ pkgs.btop ];
      files.".config/btop/btop.conf".text = ''
        theme_background=False
      '';
    }
  ]; # end of config
}
