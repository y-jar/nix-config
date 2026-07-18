{ config, lib, pkgs, ... }:
let
  hjm = config.hjmSettings;
in
{
  packages = with pkgs; [
    # core
    zsh

    # cli tools
    ripgrep
    fd
    bat
    fzf

    # editors (base)
  ] ++ lib.optionals hjm.browsers.enable [
    firefox
    librewolf
  ] ++ lib.optionals hjm.terminal.enable [
    foot
    kitty
    alacritty
  ] ++ lib.optionals hjm.editors.enable [
    vscodium
    zed
  ] ++ lib.optionals hjm.editors.obsidian.enable [
    obsidian
  ] ++ lib.optionals hjm.editors.nvf.enable [
    neovim # placeholder for nvf
  ] ++ lib.optionals hjm.editors.helix.enable [
    helix
  ] ++ lib.optionals hjm.discord.enable [
    discord
  ] ++ lib.optionals hjm.flatpak.enable [
    bazaar
  ] ++ lib.optionals hjm.nautilus.enable [
    nautilus
  ] ++ lib.optionals hjm.yazi.enable [
    yazi
  ] ++ lib.optionals hjm.ranger.enable [
    ranger
  ] ++ lib.optionals hjm.media.enable [
    mpv
    ffmpeg
  ] ++ lib.optionals hjm.keepass.enable [
    keepassxc
  ] ++ lib.optionals hjm.gaming.prism.enable [
    prismlauncher
  ] ++ lib.optionals hjm.gaming.heroic.enable [
    heroic
  ] ++ lib.optionals hjm.art.enable [
    blender
    krita
    gimp
    inkscape
  ] ++ lib.optionals hjm.office.enable [
    libreoffice
    pandoc
  ] ++ lib.optionals hjm.obs.enable [
    obs-studio
  ] ++ lib.optionals hjm.kdenlive.enable [
    kdenlive
  ] ++ lib.optionals hjm.japanese.enable [
    # fcitx5 + mozc placeholder
  ] ++ lib.optionals hjm.ai.enable [
    # lm studio + opencode placeholder
  ] ++ lib.optionals hjm.git.enable [
    gh
    lazygit
  ] ++ lib.optionals hjm.bluetooth.enable [
    blueman
  ] ++ lib.optionals hjm.dev.enable [
    # dev tools placeholder
  ];
}
