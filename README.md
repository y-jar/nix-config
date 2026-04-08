# NixOS Jar

---

## Intro

Hello! This is my NixOS config! The reason i started doing this was i wanted to learn more about it after finding out about some of it's core design princibles (i fuck with it alot). And after dipping my toes in it i found that i adore how it works, and similar to my neovim config, my goal is to make it my personal platform and hopefully not have to configure it often afterwards (which i have reached for Neovim). 

Learning from neovim is that i need to find a place to stop for this config and say "i can do what i want with my pc and it can grow when needed". And once i reach that, i will most certainly slow down on my config and just do touchups here and here. Anyone is welcome to fork or just watch my progress as i break things.

> NOTE For Viewers:
> I do not follow standared methods when it comes to learning and developing, so when you see alot 
> of progress or little, and then see me forgetting, just know i am learning, im just 
> a scatter-brain within a jar `<3`

### My Overall Goal

With this config, i am wanting this so fuction kinda like a atomic desktop to where i the user doesnt have to worry about breaking things and updates are almost always stable, whilst me the user able to tinker more so than compared to a standard atomic desktop. So with this goal, i am not leaning to a system that will constantly change config-wise, more so, it will change user-wise. I want to be able to linux, but i want my system to be locked but with my key to discourage changing.

---

## Set Up Guide

### i
### ii
### iii
### iiii

---

## Dev Section <3

This is where i put my plans and everything else. <3

### Dev Notes & Goals

Current State:

- Has a basic niri config, with working keybinds, minus wallpaper management
- Flatpack management for apps like local send and any other app one would want
- Obs with v412 thingy
- zsh
- a mini config file for users who just want to run a single file config

Goals:

- 

---



## Snippets for Later
Nix

# To add a default.nix in a new module folder:
{ ... }: {
  imports = [
    ./file1.nix
    ./file2.nix
  ];
}

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