# shell.nix
{ pkgs ? import <nixpkgs> {} }:

# create a shell enviroment
pkgs.mkShell {
  buildInputs = with pkgs; [
    pkg-config
    gtk3
    glib
    cairo

    # [Get a rustc wrapper that knows where the source is, or use rustup] ~1.65gib
    rustc # Safe, concurrent, practical language (wrapper script)
    rust-analyzer # Language server for the Rust language
    rustfmt # Tool for formatting Rust code according to style guidelines
    cargo # Downloads your Rust project's dependencies and builds your project
  ]; # end of build inputs

  # [This environment variable tells rust-analyzer exactly where to look]
  RUST_SRC_PATH = "${pkgs.rustPlatform.rustLibSrc}";

  # hook: https://nix.dev/manual/nix/2.34/command-ref/nix-shell.html
  shellHook =
  ''
    echo "This shell is in ~Jar~"
  '';
}
