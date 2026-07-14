{ pkgs, ... }:
{

  # ==========================[Enabled User Packages]=====================
  imports = [
    ./btop.nix
  ];

  # ==========================[User Packages]=============================
  home.packages = with pkgs; [
    # =======[Ness Jar] |>|>|>|>|>|>|>
    # [Base]
    wine # Wine is a compatibility layer for running Windows programs on Unix-like systems
    lynx # text-based web browser
    popsicle # iso burner
    kdePackages.isoimagewriter # iso burner
    caligula # image burner
    jq # Lightweight and flexible command-line JSON processor [needed for my jsearch script]
    # comma # Runs programs without installing them

    # [management]
    # gearlever # Manages app images
    hyprpicker # The mouse-following color picker
    woomer # Zoomer application for Wayland inspired by tsoding's boomer
    # =======[Ness Jar] |>|>|>|>|>|>|>

    # =======[Folding Jar] |>|>|>|>|>|>|>
    # [Text Editors]
    # helix # Post-modern modal text editor
    # =======[Folding Jar] |>|>|>|>|>|>|>

    # =======[Looks Jar] |>|>|>|>|>|>|>
    # [cursors]
    catppuccin-cursors # matches catppuccin theme
    # =======[Looks Jar] |>|>|>|>|>|>|>^^^

    # =======[Dev Jar] |>|>|>|>|>|>|>
    # [cli / tui / tools]
    tldr # Simplified and community-driven man pages
    bat # Cat(1) clone with syntax highlighting and Git integration
    jp # json parser
    fzf # fuzzy finder
    fd # Simple, fast and user-friendly alternative to find
    tree # Command to produce a depth indented directory listing
    cowsay # MOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
    python314Packages.pyyaml
    # =======[Dev Jar] |>|>|>|>|>|>|>^^^

    # ====Unsorteds====
  ]; # end of systemPackages
}
