# ╃
#  .▀▀█▀▀ .
#    :▓.:   ar <3
# . ▀▀ : ╃
# -=-=-=-=-=-=-=-=-=-=-=
# goal: General user packages bucket.
# -=-=-=-=-=-=-=-=-=-=-=
{
  pkgs,
  lib,
  osConfig,
  inputs,
  ...
}:
{

  # ==========================[Enabled User Packages]=====================
  imports = [
    ./btop.nix
  ];

  # ==========================[User Packages]=============================
  home.packages =
    with pkgs;
    [
      # =======[Ness Jar] |>|>|>|>|>|>|>
      # [Base]
      wine # Wine is a compatibility layer for running Windows programs on Unix-like systems
      lynx # text-based web browser
      popsicle # iso burner
      caligula # image burner in the cl
      jq # Lightweight and flexible command-line JSON processor [needed for my jsearch script]
      gnome-disk-utility # Udisks graphical front-end

      # =======[Dev Jar] |>|>|>|>|>|>|>
      # [cli / tui / tools]
      tldr # Simplified and community-driven man pages
      bat # Cat(1) clone with syntax highlighting and Git integration
      jp # json parser
      fzf # fuzzy finder
      fd # Simple, fast and user-friendly alternative to find
      tree # Command to produce a depth indented directory listing
      cowsay # MOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
      # =======[Dev Jar] |>|>|>|>|>|>|>^^^

      # =======[Nix Jar] |>|>|>|>|>|>|>
      # [nix tools]
      nix-output-monitor # prettier nix build output (nom)
      nix-tree # visualize nix dependency tree
      nurl # fetch a URL and output a nix hash
      nix-init # generate a nix package from a repo URL
      noogle-search # search Nix functions from the CLI
      # =======[Nix Jar] |>|>|>|>|>|>|>^^^

      # =======[CLI Jar] |>|>|>|>|>|>|>
      # [cli tools]
      gum # interactive CLI prompts, confirmations, choosers
      lla # modern ls with icons, plugins, gitignore
      ripgrep # fast recursive grep (better than grep -r)
      sd # sed alternative, intuitive find-and-replace
      trash-cli # safe rm to trash instead of permanent delete
      chafa # terminal image/file viewer with sixel/kitty support
      cliamp # CLI music player
      # =======[CLI Jar] |>|>|>|>|>|>|>^^^

      # ====Unsorteds====
    ]
    ++ lib.optionals osConfig.sysSettings.UseNixPkgsYoinks.enable [
      inputs.rsakura.packages.x86_64-linux.default # a cool thing whisper did, awesone of them to add it as a pkgs in nix! ref: https://github.com/preprocessor/rsakura
    ];
  # end of systemPackages
}
