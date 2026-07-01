{ pkgs, ... }:
{

  # ==========================[Enabled User Packages]=====================

  # ==========================[User Packages]=============================
  home.packages = with pkgs; [
    # =======[Ness Jar] |>|>|>|>|>|>|>
    # [Base]
    wine # Wine is a compatibility layer for running Windows programs on Unix-like systems
    lynx # text-based web browser
    popsicle # iso burner
    kdePackages.isoimagewriter # iso burner
    caligula # image burner

    # [management]
    # gearlever # Manages app images
    # =======[Ness Jar] |>|>|>|>|>|>|>

    # =======[Folding Jar] |>|>|>|>|>|>|>
    # [Text Editors]
    # helix # Post-modern modal text editor
    qownnotes # markdown app editor
    buffer # Minimal editing space for all those things that don't need keeping
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
    btop # Monitor of resources
    fzf # fuzzy finder
    fd # Simple, fast and user-friendly alternative to find
    tree # Command to produce a depth indented directory listing
    cowsay # MOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO
    # =======[Dev Jar] |>|>|>|>|>|>|>^^^

    # ====Unsorteds====
  ]; # end of systemPackages
}
