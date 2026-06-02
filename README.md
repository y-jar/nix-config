# NixOS Jar *(YEN26.5.28)*
> By Park(ME)!

Hello! This is my NixOS config! The reason i started doing this was i wanted to learn more about it after finding out about some of it's core design princibles (i fuck with it alot). And after dipping my toes in it i found that i adore how it works, and similar to my neovim config, my goal is to make it my personal platform and hopefully not have to configure it often afterwards (which i have reached for Neovim). 

> NOTE For Viewers:
> I do not follow standared methods when it comes to learning and developing, so when you see alot 
> of progress or little, and then see me forgetting, just know i am learning, im just 
> a scatter-brain within a jar `<3`

### My Overall Goal

I want a simple yet full config for my daily needs. And documented enough for others to understand my lack of skill :P .

---

## Set Up Guide

Here is where you can follow a basic guide on how to install my config.

### i

**Clone repo into dir:**
> NOTE: Might need to install git via a text editor in `/etc/nixos/configuration.nix`.
```
git clone https://github.com/y-jar/nix-config.git ~/nix-config
cd ~/nix-config
```

*To install Git if you dont want it forever*
```bash
nix-shell -p git
# then type exit in the shell when done
```

### ii

**Switch over hardware config:** *(Please read)*
> NOTE: Replace 'HOSTNAMEPLACEHOLDER' with your chosen host name.
> ME: `tyun`, `vmo`, `flipped-shark`, `calender`, `aanri`.
```bash
cp /etc/nixos/hardware-configuration.nix ~/nix-config/hosts-jar/HOSTNAMEPLACEHOLDER/hardware-configuration.nix
```
**Add / Switch Bootloader Options**
You will need to check the boot options within `/etc/nixos/configuration.nix` (it should be near the top at the `imports` section). And after finding it, copy the lines over to the respective `hosts-jar/HOSTNAME/default.nix` spot you choose in the file

### iii

**Create your `local.nix`:**
This file is gitignored and holds your machine-specific hostname so it never conflicts across machines when you (or most likely i) do a push & or pull.

Make the file directly
```bash
echo '{ chosenHost = "HOSTNAMEPLACEHOLDER"; }' > ~/nix-config/local.nix
```
Then protect it so git never accidentally commits or overwrites your local changes:
```bash
git update-index --skip-worktree ~/nix-config/local.nix
```
> NOTE: When adding your own hostname, make sure a matching `hosts-jar/HOSTNAME/default.nix` exists, or it will NOT work. *(You can copy `hosts-jar/nixos/default.nix` as a starting point)*
> And for systems that use newer hardware refer to what i use in hosts-jar/calender/default.nix . I made some changes that might help for some users.

### iV

**Initialize Git Jar:**
*(needed so flakes work)*
```bash
cd ~/nix-config
git add .
```

### V

**Switch System Configs**
*(the switch)*
> NOTE: Please change out `HOSTNAMEPLACEHOLDER` with the name of the system.
```bash
cd ~/nix-config
nixos-rebuild switch --sudo --flake .#HOSTNAMEPLACEHOLDER
```

**Or**

**To just Test the Config**
> NOTE: Please change out `HOSTNAMEPLACEHOLDER` with the name of the system.
```bash
sudo nixos-rebuild test --flake .#HOSTNAMEPLACEHOLDER
```

---



## Post install and Switch
After doing a install and switching to the new config, here are some basic steps towards personalizing the system.

### Where Do I Install Apps
Apps Can be installed via the built in app stores, or via configuring the config.

**App Stores Current:**
- Bazaar
- gnome-software

**How to Manually Add Apps / Packages**
- **In-Config (Not Prefered)**:
  - System Packages: `/nix-config/modules-jar/sys-bin/configuration.nix` at the `System Packages` section.
  - User Packages: `/nix-config/modules-jar/home-jar/default.nix` at the `User Packages` section.
- **In Terminal(Temp Apps)**
  - `nix-shell -p NAMEOFPACKAGE` This will go away.
- **App Stores (Ideal in my choice)**
  - Go to bazaar, pick an app, install and run `:)`

### How do I Update My System / Apps?
Depending on what, this can be done in two ways: `flatpak app updates`, or `system & system app updates`.

- **Apps On Flathub or Is a Flatpak**
  - Go in the appstore of your choice, navigate to updates, click update.
- **Apps in system And System**
  - > You would run this after a period of time, or making a change to the config.
  - Run `cd ~/nix-config` then run `git add .` so the command below can work `:)`
  - Run `nru` (refer to `./scripts-bin/nru.sh` for how to do it manually)


---



## Dev Section <3

This is where i put my plans and everything else. <3

### Dev Notes & Goals

**Current State:**
- basic Configs for DEs and WMs
- Set of Apps and settings for Background apps
- 

**Goals:**
- adding streamlined updating or something, rightnow updating is a bit spooky [ DONE ]
- add `gnome` [ DONE ]
- **actual working configs for these systems**
  - `yilyonix` [In Progress]
  - `tyun`, 
  - `vmo`, 
  - `flipped-shark` [In Progress] 
  - `calender`, [In Progress]
  - `aanri`.
- a set up guide `[DONE]`.
- **`flipped-shark` Goals**
  - Battery not being capped at 80. `[ TAKING A BREAK FROM IT ]`
  - increase battery life by 1hr. `[ WIP ]`
  - fix the missing 10 sensors for `flipped-shark` so the gyro and some other fucntions can work. `[ DONE ]`
- add gnome as a option.  `[ DONE ]`
- **Niri Goals** `[ RELAXED - ONGOING ]`
  - Better `waybar` or use a prebuilt `qs` `[ DONE ]`
  - fix rendering issues for `steam` showing up as black.. i have no clue why it's like this. [ WIP ]
  - update to latest noctalia `[ WAITING ]`
- **Hyprland Goals** `[ NOT IN PROGRESS ]`
  - Colors or something... 
  - make it slay
  - make custom icons for backdrop
- **Sway Goals** `[ NOT IN PROGRESS ]`
  - mm keybinds
  - fuzzel, and other good apps.
  - Theming
- **Audio**
  - BIG KOOL `[ DONE ]`

---

## Snippets for Later
In case i go insane and forget things...

### Game tweaks

**steam**:
- for anti-cheat preventing a game to launch but it does support linux, use this: `PROTON_EAC_RUNTIME=1 %command%`
- for game audio issues..: `PULSE_SINK=game_audio %command%`

### Nix forgetfulnes
```nix
{ nameofmoduleorpkgtopass, ... }: {
  imports = [
    ./file1.nix # prefer to add comments
    ./file2.nix # here
  ];
}
```

**Commands To remember for basic stuff..**
```bash
nrs # swap into new config
nrt # test into new config
nru # update, switch, and clean combo
```
> NOTE: Please reboot before updating `:)`

**When new nixOS version is out**
1. fix errors presented
2. when updating, expect a shutdown, just restart and it should be fine
3. after some adjustemts run a nru whilst in the new NixOS update