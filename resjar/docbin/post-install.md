
**Links:**
- [Back Home](../../README.md)
- [back to documentation key](./key-key.md)

# Post Install

## What's Next to Do?
Well some important things to do after installing are:

### How do I switch to a newer version of the nixos config?
To switch to a newer version of the nixos config(after updating), you can run the following commands:
```bash
cd ~/nix-config && git add .
nrs # rebuild system with new config
nhu # rebuild system with new config but using nix helper
```

### How do I Update My System / Apps?
Depending on what, this can be done in two ways: `flatpak app updates`, or `system & system app updates`.

- **Apps On Flathub or Is a Flatpak**
  - Go in the appstore of your choice, navigate to updates, click update.
- **Apps in system And System**
  - > You would run this after a period of time, or making a change to the config.
  - Run `cd ~/nix-config` then run `git add .` so the command below can work `:)`
  - Run `nru` (refer to `./scripts-bin/nru.sh` for how to do it manually) `[note. utilizes nh when it should be using the regular nixos-rebuild commands]`
  - Run `nhu` (refer to `./scripts-bin/nhu.sh` for how to do it manually) `[note. not implemented yet]`
