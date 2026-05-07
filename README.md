# NixOS Jar *(YEN26.5.2)*
By Park(ME)!

---



### Intro

Hello! This is my NixOS config! The reason i started doing this was i wanted to learn more about it after finding out about some of it's core design princibles (i fuck with it alot). And after dipping my toes in it i found that i adore how it works, and similar to my neovim config, my goal is to make it my personal platform and hopefully not have to configure it often afterwards (which i have reached for Neovim). 

Learning from neovim is that i need to find a place to stop for this config and say "i can do what i want with my pc and it can grow when needed". And once i reach that, i will most certainly slow down on my config and just do touchups here and here. Anyone is welcome to fork or just watch my progress as i break things.

> NOTE For Viewers:
> I do not follow standared methods when it comes to learning and developing, so when you see alot 
> of progress or little, and then see me forgetting, just know i am learning, im just 
> a scatter-brain within a jar `<3`

### My Overall Goal

With this config, i am wanting this to fuction kinda like a atomic desktop to where i, the user doesnt have to worry about breaking things and updates are almost always stable, whilst me the user able to tinker more so than compared to a standard atomic desktop. So with this goal, i am not leaning to a system that will constantly change config-wise, more so, it will change user-wise. I want to be able to linux, but i want my system to be locked but with my key to discourage changing.

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

**Make your Host Name Changes:**
For the last step to work this needs to be changed to your picking at this section within `flake.nix`.
*(Pick the hostname you picked for the steps before):* `tyun`, `vmo`, `cold-flip`, `calender`, `aanri` *Or others that was made for their own systems*
```nix
  #=====================================MAKE CHANGES HERE==============================================
	chosenHost = "yilyonix"; # this mainly affects the window manager sub option, making sure screen stuff works.
```
> NOTE, when adding your own hostname, be aware to add the respective `hosts-jar/HOSTNAME/default.nix` to the config, or it will NOT work. *(you can just copy `hosts-jar/nixos/default.nix` to get it to work)*

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
- 

---



## Dev Section <3

This is where i put my plans and everything else. <3

### Dev Notes & Goals

**Current State:**
- Has a basic niri config, with working keybinds, minus wallpaper management
- Flatpack management for apps like local send and any other app one would want
- Obs with v412 thingy
- zsh
- a mini config file for users who just want to run a single file config

**Goals:**
- adding streamlined updating or something, rightnow updating is a bit spooky [ DONE ]
- add `gnome` [ DONE ]
- **actual working configs for these systems**
  - `yilyonix` [In Progress]
  - `tyun`, 
  - `vmo`, 
  - `flipped-shark` [In Progress]
  - `calender`, 
  - `aanri`.
- a set up guide `[DONE]`.
- **`flipped-shark` Goals**
  - Battery not being capped at 80. [ TAKING A BREAK FROM IT ]
  - increase battery life by 1hr. [ WIP ]
  - fix the missing 10 sensors for `flipped-shark` so the gyro and some other fucntions can work. [ DONE ]
- add gnome as a option.  [ DONE ]
- **Niri Goals**
  - Better `waybar` or use a prebuilt `qs` [ WIP ]
  - fix rendering issues for `steam` showing up as black.. i have no clue why it's like this 

---



## Snippets for Later
Nix

# To add a default.nix in a new module folder:
```nix
{ nameofmoduleorpkgtopass, ... }: {
  imports = [
    ./file1.nix # prefer to add comments
    ./file2.nix # here
  ];
}
```


to update the system AFTER Switching

> NOTE: Please reboot before updating `:)`

```bash/zsh
nru
```
