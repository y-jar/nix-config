# auto-import.nix [EXPLAINED BY AN AI MODEL - Jar :) ]
# ─────────────────────────────────────────────────────────────────────────────
# DROP THIS FILE into any folder as default.nix and it will automatically
# import every .nix file in that folder (and subfolders).
#
# WHY THIS EXISTS:
#   Normally you'd maintain an imports list by hand:
#     imports = [ ./audio.nix ./gaming.nix ./users.nix ];
#   Every time you add a new module you have to remember to add it here too.
#   This file eliminates that — just drop a .nix file in the folder and it
#   gets picked up on the next rebuild automatically.
#
# HOW TO USE IT:
#   1. Save this file as default.nix inside a module folder.
#      Example: modjar/sysbin/default.nix
#   2. That's it. Any .nix file you add to modjar/sysbin/ or its subfolders
#      will be imported automatically.
#
# WHAT IT SKIPS:
#   - default.nix itself (this file) — avoids an infinite loop
#   - Anything that doesn't end in .nix
#
# ─────────────────────────────────────────────────────────────────────────────

{ lib, ... }:

let
  # ── STEP 1: Read the folder ──────────────────────────────────────────────
  # builtins.readDir returns an attrset like:
  #   { "audio.nix" = "regular"; "gaming" = "directory"; "users.nix" = "regular"; }
  # "regular" means it's a plain file. "directory" means it's a subfolder.
  dirContents = builtins.readDir ./.;

  # ── STEP 2: Filter to only .nix files, skip this file itself ─────────────
  # lib.filterAttrs keeps only the entries where the function returns true.
  # We want:
  #   - type == "regular"   → it's a file, not a subfolder
  #   - hasSuffix ".nix"    → it's a nix file
  #   - name != "default.nix" → don't import ourselves (infinite loop!)
  nixFiles = lib.filterAttrs (
    name: type: type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix"
  ) dirContents;

  # ── STEP 3: Also collect subfolders ──────────────────────────────────────
  # When NixOS sees a folder in an imports list, it automatically looks for
  # a default.nix inside it. So we can just list the folder paths here.
  # If a subfolder doesn't have a default.nix, the rebuild will error and
  # tell you — which is a useful reminder to add one.
  subDirs = lib.filterAttrs (name: type: type == "directory") dirContents;

  # ── STEP 4: Build the final list of paths ────────────────────────────────
  # builtins.attrNames gives us the list of keys (file/folder names).
  # We then prefix each with ./  so Nix knows they're relative to this file.
  #
  # ./. + "/${name}" is Nix path concatenation. It turns:
  #   "audio.nix"  →  /absolute/path/to/modjar/sysbin/audio.nix
  #   "gaming"     →  /absolute/path/to/modjar/sysbin/gaming
  #                   (NixOS will look for gaming/default.nix automatically)
  filePaths = map (name: ./. + "/${name}") (builtins.attrNames nixFiles);
  dirPaths = map (name: ./. + "/${name}") (builtins.attrNames subDirs);
in
{
  imports = filePaths ++ dirPaths;
  # The ++ just concatenates the two lists into one.
  # Example result:
  #   imports = [
  #     /path/to/sysbin/audio.nix
  #     /path/to/sysbin/users.nix
  #     /path/to/sysbin/gaming        ← folder, NixOS finds gaming/default.nix
  #     /path/to/sysbin/niri          ← folder, NixOS finds niri/default.nix
  #   ];
}
