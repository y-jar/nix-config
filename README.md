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
  <h1 style="color:#d3866d; border-bottom: none; font-size: 2.5em; margin-bottom: 0;">NixOS in a Jar ❄️</h1>
  <code style="background-color: #3e3835; color: #e6dbb2; padding: 4px 8px; border-radius: 4px;">Version: Iler-26.6.13</code>
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
    <!--<a href="https://github.com/">
      <img src="https://img.shields.io/github/repo-size/y-jar/nix-config?style=for-the-badge&logo=github&logoColor=white" alt="Repo Size"/>
    </a>-->
    <!-- install guide -->
    <a href="./resjar/docbin/install-guide.md">
      <img src="https://img.shields.io/badge/Documentation-Installation%20Guide-d3866d?style=for-the-badge&logo=markdown&logoColor=white" alt="Installation Guide"/>
    </a>
    <!-- directory documentaions -->
    <a href="./resjar/docbin/directory-key.md">
      <img src="https://img.shields.io/badge/Repository-Directory%20Key-8a7a71?style=for-the-badge&logo=git&logoColor=white" alt="Directory Key"/>
    </a>
    <!-- header bottom -->
    <hr style="width: 90%; border: 1px solid #4f4742; margin-top: 20px;" />
  </p>
</div>

<!-- my intro <3 -->
<div align="center">
  <p style="max-width: 750px; margin: 0 auto; line-height: 1.6; color: #bcac9b;">
    Hello! This is my NixOS config! The reason i started doing this was i wanted to learn more about it after finding out about some of it's core design princibles. And after dipping my toes in it i found that i adore how it works, and similar to my neovim config, my goal is to make it my personal platform and hopefully not have to configure it often extensively afterward.
  </p>
</div>
<br>

<!-- Notes for Outsiders -->
> [!NOTE] for outsiders, the install guide is located in the [install-guide](resjar/docbin/install-guide.md) file.

> **This config is intended for NixOS users only.** And is currently focused on configuring my personal NixOS setup. So please be aware that some of the config may not be applicable to your setup.

<!--===========SUMMERY=============-->

---
<!--System stats, stating options like server stuff, browsers, capabilities-->
### System Stats =-=-=-=-=-

<details>
  <summary><b>Current State</b></summary>
  <p>The system configuration is fully modular, functional, and split into system-level hardware declarations (<code>sysSettings</code>) and modular user-space profiles (<code>usrSettings</code>) managed via Home Manager and Flakes.</p>
  
  #### Core Features:
  - **Modular Profiles:** Separate configs for real hardware hosts (`loom`, `whale`) and nested development spaces (`vmjar`).
  - **Automated Bootstrapping:** A custom interactive installer shell environment for smooth hardware onboarding and git deployment tracking.
  - **Robust Fallbacks:** Centralized templates and error safety guardrails built directly into our local module paths (`modjar/`).

  #### What this Config isn't:
  - **A Flake-Parts Config:** The reason why is simple, Simplicity is my best policy.
  - **A Catch-All Config:** We Don't want unwanted bloat (wanted bloat on the other hand... `>:)`)
</details>

<details>
  <summary><b>Shell Stats & Interactive Env Tools</b></summary>
  
  My dedicated installer utility shell automates the install process.

  | Command | Type | Action |
  | :--- | :--- | :--- |
  | `hardto <host>` | Function | **(Installer Shell Only)** Generates a fresh profile folder layout from `0_TEMPLATE` and drops the system's live hardware configurations inside. |
  | `nhs <host>` | Function | Builds and instantly deploys the global NixOS configuration utilizing `nh`. <br>*(Note: **No argument required** after install; typing `nhs` on your deployed system automatically targets your active host).* |
  | `hms <user>` | Function | Isolates, updates, and activates strictly the user-space Home Manager profile. <br>*(Note: **No argument required** after install).* |
  | `nht <host>` | Function | Safely tests a configuration compilation run without writing to the active bootloader profile. <br>*(Note: **No argument required** after install; typing `nht` automatically tests your current host).* |
  | `jc <message>`| Function | Automated commit handler that joins multi-word sentences cleanly. |
  | `nhc` | Alias | System sanitation maintenance rule (cleans all generations, keeps the last 7 profiles). |
  | `chkhrd` | Alias | Runs `lsblk` and `fdisk -l` for storage block verification. |
</details>

<details>
  <summary><b>Digital Workspace Aesthetic & Looks</b></summary>
  
  The desktop layout is built for function `<3`.

  #### Core Desktop Environments & Compositors:
  - **Hyprland:** Highly customized, dynamic tiling Wayland compositor.
  - **Niri:** A scrollable-tiling window manager environment.
  - **GNOME:** Full classic desktop environment infrastructure for standardized app layout support.
  - **Cinnemon:** Full classic desktop environment infrastructure for standardized app layout support.

  #### Aesthetic Highlights:
  - Custom user themes and specific environment styling configurations managed loosely under `usrSettings`.
  - Transparent layouts hints.
</details>

<details>
  <summary><b>Optional Applications & System Setup</b></summary>
  
  The system follows a simple boolean toggle switch sheet (`true`/`false`) in `system.nix` and `user.nix`. You can scale this feature checklist up or down with ease:

  ### System Toggles (`system.nix`)
  - **Virtualization Support:** Host-level tools (`libvirtd`, `virt-manager`, `gnome-boxes`, `swtpm`) or automated VM Guest optimization integrations (`qemuGuest`, `spice-vdagentd`).
  - **Gaming Infrastructures:** Centralized driver setups for graphics processing.
  - **Media & Sync Daemons:** Integrated server backends (like `jellyfin` media servers with simple ownership management).
  - **Automation:** Power maintenance daemons (like `sleepyjar` for automated system intervals and reboot behaviors). `[basic, i am still learning]`

  ### Application Toggles (`user.nix`)
  - **Development Environments:** Added apps like `zeditor`, and `vscodium` or TUI based ones like my `nvf`(neovim) for stuff that requires the terminal.
  - **File Navigation Ecosystem:** TUI and GUI file systems loaded on-demand (`yazi`, `nautilus`, `ranger`).
  - **Privacy Utilities:** An oldy but a goody, (`keepassxc`).
  - **Creative Stacks:** Optional graphics systems, rendering workspaces, and video production setups (`art` tools, `obs-studio`, `kdenlive`).
  - **Language & Modifiers:** Dedicated custom input layers and native support structures (such as `japanese` language input frameworks).
</details>

<!-- My system Configuration information stats -->
## System Layout =-=-=-=-=-

> [!NOTE] This config is currently in a state of active development.

1. [flake.nix](flake.nix): the main flake file that defines the system and the per-system configurations.
2. [res/](./resjar): the directory containing all the resource for the config and repository.
3. [modjar/](./modjar): the directory containing all the NixOS modules. And inside:
  4. [user bin/](./modjar/usrbin): the home-manager dir for user configuration per user.
  5. [system bin/](./modjar/sysbin): the NixOS system configuration for **all** configurations.
  6. [host jar/](./hstjar): the NixOS host configurations are in here.
4. [rot jar/](./rotjar): the dir to contain any files that are in rotaion for references, work, etc... Anything in there will not be around for long.

> click [here](resjar/docbin/key-key.md) to see the **Full** Documentation.

## Dev Section
<!-- goals / working projects -->
For anything related to development, please see the [dev section](./resjar/docbin/dev-key.md) for more details.
