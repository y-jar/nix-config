<!-- ref:
Paste:
<p><a href="">Here</a></p>
<img src="">
-->
<!-- alert, hidden when not needed <3 -->
<div>
  <blockquote>
    <p><strong>ALERT:</strong> A heavy rewrite was recently completed. Error checking is actively underway, and improved front-end documentation will be added iteratively. Time will tell when the polish is fully out!</p>
  </blockquote>
</div>
<br>

<!-- My title Jar <3 -->
<div align="center">
  <h1 style="color:#d3866d; border-bottom: none; font-size: 2.5em; margin-bottom: 0;">NixOS Jar ❄️</h1>
  <code style="background-color: #3e3835; color: #e6dbb2; padding: 4px 8px; border-radius: 4px;">Generation: Iler-26.6.4</code>
  <p style="margin-top: 10px; color: #8a7a71;"><i>Written by me! [Park / Jar]</i></p>
</div>

<!-- My header Stats <3> -->
<div align="center">
  <p>
      <!-- link to nixos -->
    <a href="https://nixos.org/">
      <img src="https://img.shields.io/badge/NixOS-Official%20Site-5277C3?style=for-the-badge&logo=nixos&logoColor=white" alt="NixOS Official Website"/>
    </a>
    <!-- Repo Size -->
    <a href="https://github.com/">
      <img src="https://img.shields.io/github/repo-size/y-jar/nix-config?style=for-the-badge&logo=github&logoColor=white" alt="Repo Size"/>
    </a>
    <!-- install guide -->
    <a href="./res/doc-bin/install-guide.md">
      <img src="https://img.shields.io/badge/Documentation-Installation%20Guide-d3866d?style=for-the-badge&logo=markdown&logoColor=white" alt="Installation Guide"/>
    </a>
    <!-- directory documentaions -->
    <a href="./res/doc-bin/directory-key.md">
      <img src="https://img.shields.io/badge/Repository-Directory%20Key-8a7a71?style=for-the-badge&logo=git&logoColor=white" alt="Directory Key"/>
    </a>
    <!-- header bottom -->
    <hr style="width: 90%; border: 1px solid #4f4742; margin-top: 20px;" />
  </p>
</div>

<!-- my intro <3 -->
<div align="center">
  <p style="max-width: 750px; margin: 0 auto; line-height: 1.6; color: #bcac9b;">
    Hello! This is my NixOS config! The reason i started doing this was i wanted to learn more about it after finding out about some of it's core design princibles. And after dipping my toes in it i found that i adore how it works, and similar to my neovim config, my goal is to make it my personal platform and hopefully not have to configure it often extextensively afterward.
  </p>
</div>
<br>

<!-- Notes for Outsiders -->
> [!NOTE] for outsiders, the install guide is located in the
> [install-guide](res/doc-bin/install-guide.md) file. A script will be available soon to
> automate the installation process.

> [!IMPORTANT] This config is intended for NixOS users only. And is currently focused on 
> configuring my personal NixOS setup. So please be aware that some of the config may not be
> applicable to your setup.

<!-- current state -->
<details><summary>Current State</summary>
  <p>the current state of the config is *mostly* functional, with some missing features and bugs to be fixed.</p>
</details>

<!-- link to layout -->
> click [here](res/doc-bin/directory-key.md) to see the **Full** directory layout.

<!-- My system Configuration information stats -->
## System Layout

> [!NOTE] This config is currently in a state of active development.

1. [flake.nix](flake.nix): the main flake file that defines the system and the per-system configurations.
2. [res/](./res): the directory containing all the resource for the config and repository.
3. [modules/](./modules): the directory containing all the NixOS modules. And inside:
  - [home-jar/](./modules/home-jar): the home manager configuration Directory.
  - [sys-bin/](./modules/sys-bin): the NixOS system configuration for **all** configurations.
  - [host-jar/](./modules/host-jar): the NixOS host configurations are in here.
  - [nix-bin/](./modules/nix-bin): the Nix settings are within here (like experimental features etc..).
4. [rot-jar/](./rot-jar): the dir to contain any files that are in rotaion for references, work, etc... Anything in there will not be around for long.


## Dev Section
<!-- goals / working projects -->

### Dev Notes & Goals

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
- **Hyprland Goals** `[ KINDA IN PROGRESS ]`
  - Colors or something... 
  - make it slay
  - make custom icons for backdrop
- **Sway Goals** `[ NOT IN PROGRESS ]`
  - mm keybinds
  - fuzzel, and other good apps.
  - Theming
  - 
- **Audio**
  - BIG KOOL `[ DONE ]`
- **add-ons**
  - flake parts `[ researching ... ]`
  - ...