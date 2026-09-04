# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: `jn` (jar's nix shell) - a playful interactive shell launcher.
# Shows the jar banner, runs a gum "favorite plant?" quiz, then spawns a
# themed `nix shell` based on the answer. Per-host gated on
# sysSettings.unfree.enable and sysSettings.UseNixPkgsYoinks.enable.
# -=-=-=-=-=-=-=-=-=-=-=
{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  # Per-host gates.
  unfreeAllowed = osConfig.sysSettings.unfree.enable or false;
  yoinkEnabled = osConfig.sysSettings.UseNixPkgsYoinks.enable or false;
  # rsakura is only offered when the host trusts the yoinks overlay AND unfree.
  seaweedHasRsakura = yoinkEnabled && unfreeAllowed;

  # Unfree handling: only apply the allow-unfree env + --impure when allowed.
  prefix = lib.optionalString unfreeAllowed "env NIXPKGS_ALLOW_UNFREE=1";
  impure = lib.optionalString unfreeAllowed "--impure";

  banner = builtins.readFile ../../../resjar/asciiartbin/jart;

  # The "correct answer" (moss) opens a generous free toolkit.
  mossSet = "nixpkgs#cowsay nixpkgs#sl nixpkgs#cmatrix nixpkgs#cbonsai nixpkgs#figlet nixpkgs#lolcat nixpkgs#fortune nixpkgs#btop nixpkgs#htop nixpkgs#bat nixpkgs#fzf nixpkgs#ripgrep nixpkgs#git nixpkgs#curl nixpkgs#jq nixpkgs#tree nixpkgs#fastfetch nixpkgs#nyancat nixpkgs#oneko";
  mossLabel = "cowsay, sl, cmatrix, cbonsai, figlet, lolcat, fortune, btop, htop, bat, fzf, ripgrep, git, curl, jq, tree, fastfetch, nyancat, oneko";

  jn = pkgs.writeShellScriptBin "jn" ''
    set -eu

    # jar banner
    cat <<'JART'
    ${banner}
    JART

    # gum quiz
    choice="$(nix shell nixpkgs#gum -c gum choose \
      --header "<jar???> Haro! I'm Jar! And what is my favorite plant?" \
      "1 - birch Tree? (no apples???)" \
      "2 - seaWEED (fish don't mess with this stuff)" \
      "3 - moss (definitely not lettuce)")"

    case "$choice" in
      *moss*)
        # reward: themed interactive shell with the toolkit
        printf '%s\n' "<jar???> These apps were installed: ${mossLabel}"
        printf '%s\n' "<jar???> Have a fun time in the jar!"
        exec ${prefix} nix shell ${impure} ${mossSet} -c zsh
        ;;
      *birch*)
        # run btop directly
        exec ${prefix} nix run ${impure} nixpkgs#btop
        ;;
      *seaWEED*)
        ${lib.optionalString seaweedHasRsakura ''
          # run rsakura (silly visual TUI); explicit binary name (upstream pkg is named nsakura)
          exec ${prefix} nix shell ${impure} "$HOME/nix-config#rsakura" -c rsakura
        ''}
        ${lib.optionalString (!seaweedHasRsakura) ''
          # rsakura not enabled on this host -> fall back to a random ascii-art toy
          exec ${prefix} nix run ${impure} "nixpkgs#''$(shuf -n1 -e cmatrix nyancat oneko pipes.sh cbonsai sl)"
        ''}
        ;;
    esac
  '';
in
{
  config = {
    home.packages = [ jn ];
  };
}
