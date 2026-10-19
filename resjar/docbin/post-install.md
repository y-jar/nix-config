**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Post Install

## Switching to a newer config

After pulling changes:

```bash
cd ~/nix-config
git add .        # flake needs to see the files
nhs              # deploy with nh (or nrs for the nixos-rebuild fallback)
```

## Updating the system and apps

Two paths:

- **Flatpaks**: open your app store, go to updates, update.
- **System + system apps**: after a while, or after a config change:

```bash
cd ~/nix-config
git add .
nru              # update flake inputs + rebuild
nhs              # deploy
```
