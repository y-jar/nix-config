Nix-in-a-Jar (yil-jar)

This is my NixOS evolution. I moved away from the standard /etc/nixos mess to a modular Flake setup in my home directory. It’s cleaner, version-controlled, and actually makes sense.
System Map


# Emergency Recovery
# If I break the config so bad I can't boot, I just pick an 
# older generation at the boot menu to roll back instantly.

Dev Notes & Goals

Current State:

   - [x] Migrated from /etc/nixos to ~/nix-config.

   - [x] Modularized Zsh and Terminal configs using .nix.

   - [x] Fonts now work
   
   - [x] groundwork for WMs are set up

Short-term Goals:

   - [ ] Modularize further: Add a default.nix to every sub-directory in modules/. This will let me import a whole folder (e.g., ./modules/desktop) instead of listing every single file in the home brain.

   - [ ] Sway Polish: Move keybindings out of the system level and into modules/desktop/sway.nix.

   - [ ] Bar config: Set up Waybar with custom CSS.

Code Snippets for Later:
Nix

# To add a default.nix in a new module folder:
{ ... }: {
  imports = [
    ./file1.nix
    ./file2.nix
  ];
}

Why I built it this way

I wanted the system to be "breathable." By using imports = [ ... ] in a central default.nix, I can comment out a single line to disable an entire part of my desktop (like Sway) without deleting the code. It's built for experimentation.

Don't forget: Always git add README.md if you make big changes here so the documentation lives and dies with the code version. You will thank me ME

to update the repositories
```
cd ~/nix-config/
nix flake update
```
to update the system after updating the repos
```
sudo 
```