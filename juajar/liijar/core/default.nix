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
      packages = [
        # =======[core shell]
        pkgs.zsh

        # =======[cli tools]
        pkgs.ripgrep # fast recursive grep (better than grep -r)
        pkgs.fd # Simple, fast and user-friendly alternative to find
        pkgs.bat # Cat(1) clone with syntax highlighting and Git integration
        pkgs.fzf # fuzzy finder
        pkgs.zoxide # smarter cd
        pkgs.jq # Lightweight and flexible command-line JSON processor [needed for my jsearch script]

        # =======[ness jar]
        pkgs.lynx # text-based web browser
        pkgs.popsicle # iso burner
        pkgs.caligula # image burner in the cl
        pkgs.gnome-disk-utility # Udisks graphical front-end

        # =======[dev jar]
        pkgs.tldr # Simplified and community-driven man pages
        pkgs.jp # json parser
        pkgs.tree # Command to produce a depth indented listing of files
        # (cowsay lives in liijar/cowsay the commented reference example module)

        # =======[nix jar]
        pkgs.nix-output-monitor # prettier nix build output (nom)

        # =======[cli jar]
        pkgs.gum # interactive CLI prompts, confirmations, choosers
        pkgs.lla # modern ls with icons, plugins, gitignore
        pkgs.sd # sed alternative, intuitive find-and-replace
        pkgs.trash-cli # safe rm to trash instead of permanent delete
        pkgs.chafa # terminal image/file viewer with sixel/kitty support
        pkgs.cliamp # CLI music player
      ]
      # wine is opt-in (usrset.wine.enable) pulls wine-gecko + wine-mono too
      ++ lib.optionals cfg.wine.enable [
        pkgs.wine # Wine is a compatibility layer for running Windows programs on Unix-like systems
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
