**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

# Install Guide
Here is the guide to install the system. Please be sure to read the notes to ensure that you know what you are doing.

## Which path?

> **On the live ISO (new machine)?** → [Option A: Iso Install](#a-iso-install-from-the-live-iso)
>
> **On an already installed system?** → [Option B: add / update a host](#b-on-an-already-installed-system)

## A. Iso Install (from the live ISO)

`nixinstall` does an **archinstall-style base install**: it sets up drives, formats, creates your user, and installs a **core NixOS** (bootloader + NetworkManager + your user + git + flakes). It then clones `y-jar/nix-config` into `~/nix-config` **but it does NOT switch** to the full jar config. The switch is yours to pull after first boot, once your host config is ready.

### i Boot the ISO
Build it with `resjar/nixbin/buildiso.sh`, write it to a USB stick (`dd`), boot it, and log in as `nixos` (password `nixos`). Connect to Wi-Fi if needed.

### ii Run the installer
```bash
nixinstall
```
Pick **Iso Install live ISO only (erases disk)**.

> **NOTE:** Everything else in the menu is for systems that are already installed. Iso Install is the only option that touches disks.

The installer walks through: disk → boot mode → filesystem → partitioning (auto or manual cfdisk) → format → mount → network → **hostname / timezone / username / password** → core install → clone of `y-jar/nix-config` into `/home/<your-user>/nix-config` → done.

### iii First boot pull the switch
```bash
# login as your user, then:
cd ~/nix-config
nix-shell          # provides hardto / nhs / nht
hardto PICKEDHOST  # scaffold the host + yoink this machine's hardware config
# edit hstjar/PICKEDHOST/system.nix + user.nix
nhs PICKEDHOST     # deploy (this is the switch)
```

> **My predefined PICKEDHOST options** (or scaffold a brand new one):
> - `calender`: main desktop PC
> - `candle`: gaming mini build
> - `vmjar`: virtual machine config
> - `whale`: server system
> - `yilyonix`: test bench (laptop/tablet)
> - `ziiemar`: personal laptop (HP)

## B. On an already installed system

> **My predefined PICKEDHOST options**: same list as above.
> If you are adding a brand new host, please see the [add new config guide](./add-new-config-guide.md).

### i Clone
Clone The Repo:
> Run `nix-shell -p git` to install git before
```bash
git clone https://github.com/y-jar/nix-config.git ~/nix-config
cd ~/nix-config
```

### ii Run shell & add Hardware
run `nix-shell` to set up the basic tools for install `[this will also provide some tips for you <3]`
**Then run**:
```bash
hardto PICKEDHOST # <-- set your host name here [replace PICKEDHOST]
```

**Add / Switch Bootloader Options**
You will need to check the boot options within `/etc/nixos/configuration.nix` (it should be near the top at the `imports` section). And after finding it, check the lines over to the respective `hstjar/HOSTNAME/boot.nix` spot and make sure the bootloader options are correct or the same as the ones in `configuration.nix` in `/etc/nixos/`.

### iii Switch Over!
> NOTE: Replace `HOSTNAME` with the Chosen HostName That matches the Name of a `Configuration`
```bash
nhs HOSTNAME
```

<p><a href="./post-install.md">Click here for post-install Information</a></p> and
<a href="../../README.md">here for Back Home</a>
