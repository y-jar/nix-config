# =-=-=[config1-db.nix] =-=-=
# Builds mozc's binary config1.db from keymap.tsv.
# Shared by home-manager (modjar/usrbin) and hjem (modjar/hjmbin).
#
# mozc stores its config as a protobuf (mozc.config.Config) at
# ~/.config/mozc/config1.db. We encode the keymap table (TSV) into a
# textproto and compile it with protoc. The schema comes straight from
# mozc.src so it always matches the pinned mozc version.
{ pkgs }:

let
  keymap = builtins.readFile ./keymap.tsv;

  # Escape TSV content into a protobuf string literal.
  escape =
    builtins.replaceStrings
      [
        "\\"
        "\""
        "\n"
        "\t"
      ]
      [
        "\\\\"
        "\\\""
        "\\n"
        "\\t"
      ];

  textproto = pkgs.writeText "mozc-config.textproto" ''
    session_keymap: CUSTOM
    custom_keymap_table: "${escape keymap}"
  '';

  mozcSrc = pkgs.mozc.src;
in
pkgs.runCommand "mozc-config1.db"
  {
    nativeBuildInputs = [ pkgs.protobuf ];
  }
  ''
    protoc --encode=mozc.config.Config \
      --proto_path=${mozcSrc}/src \
      protocol/config.proto \
      < ${textproto} > $out
  ''
