# Guide

---

## Intro

Hello! This is my NixOS config! The reason i started doing this was i wanted to learn more about it after finding out about some of it's core design princibles (i fuck with it alot). And after dipping my toes in it i found that i adore how it works, and similar to my neovim config, my goal is to make it my personal platform and hopefully not have to configure it often afterwards (which i have reached for Neovim). 

Learning from neovim is that i need to find a place to stop for this config and say "i can do what i want with my pc and it can grow when needed". And once i reach that, i will most certainly slow down on my config and just do touchups here and here. Anyone is welcome to fork or just watch my progress as i break things.

> NOTE For Viewers:
> I do not follow standared methods when it comes to learning and developing, so when you see alot 
> of progress or little, and then see me forgetting, just know i am learning, im just 
> a scatter-brain within a jar `<3`

---

## Dev Section <3
This is where i put my plans and everything else. <3

Dev Notes & Goals

Current State:

- This 

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