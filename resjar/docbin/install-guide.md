**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

# Install Guide
Here is the guide to install the system. Please be sure to read the notes to ensure that you know what you are doing.

## Steps to Follow on a new install

> **NOTE:** 
> This guide assumes your system is of the ones i configured support for. for adding basic support for your system, please see the [add new config guide](./add-new-config-guide.md).

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

> **My predefined PICKEDHOST options**: 
> - `calender`: main desktop PC
> - `candle`: gaming mini build
> - `vmjar`: virtual machine config
> - `whale`: server system
> - `yilyonix`: test bench (laptop/tablet)
> - `ziiemar`: personal laptop (HP)

**Add / Switch Bootloader Options**
You will need to check the boot options within `/etc/nixos/configuration.nix` (it should be near the top at the `imports` section). And after finding it, check the lines over to the respective `hstjar/HOSTNAME/boot.nix` spot and make sure the bootloader options are correct or the same as the ones in `configuration.nix` in `/etc/nixos/`.

### iii
If you are adding a new config please go [here](./add-new-config-guide.md).

### iv
**Switch Over!**
> NOTE: Replace `HOSTNAME` with the Chosen HostName That matches the Name of a `Configuration`
```bash
nhs HOSTNAME
```

<p><a href="./post-install.md">Click here for post-install Information</a></p> and
<a href="../../README.md">here for Back Home</a>
