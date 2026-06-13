# Install Guide
Here is the guide to install the system. Please be sure to read the notes to asure that you know what you are doing.

**Links:**
- [Back Home](../../README.md)
- [back to documentation key](./key-key.md)

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

### ii Grab Hardware & Check Boot

**Switch over hardware config:** *(Please read)*
> NOTE: Replace 'HOSTNAMEPLACEHOLDER' with your chosen host name. 

> ME: `flipped-jar`, `calender`, `yilyonix`.
```bash
cp /etc/nixos/hardware-configuration.nix ~/nix-config/hstjar/HOSTNAMEPLACEHOLDER/hardware-configuration.nix
```

**Add / Switch Bootloader Options**
You will need to check the boot options within `/etc/nixos/configuration.nix` (it should be near the top at the `imports` section). And after finding it, check the lines over to the respective `hstjar/HOSTNAME/boot.nix` spot and make sure the bootloader options are correct or the same as the ones in `configuration.nix` in `/etc/nixos/`.

### iii

**Do the GIT!**
```bash
cd ~/nix-config && git add .
```

### iv
**Switch Over!**
> NOTE: Replace `HOSTNAME` with the Chosen HostName That matches the Name of a `Configuration`
```bash
# switching and commiting
    nixos-rebuild switch --sudo --flake ~/nix-config#HOSTNAME

# Just testing
    nixos-rebuild test --sudo --flake ~/nix-config#$HOSTNAME
```

And now you are done!.. or is it?

<p><a href="./post-install.md">Click here for post-install Information</a></p> and
<a href="../../README.md">here for Back Home</a>
