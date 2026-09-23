**Links:**
- [Back Home](../../README.md)
- [back to documentation key](./key-key.md)

---

# mcpelauncher / Minecraft Bedrock

Runbook for our `mcpelauncher-client` + `mcpelauncher-ui-qt` overlay
(`juajar/sysjar/nix/overlays-mcpe.nix`). Covers the
"Minecraft auto-updated and the launcher now crashes" failure mode, plus the
durable fix.

> [!NOTE]
> nixpkgs lags far behind upstream for this package. We pin our own version in
> an overlay so we never wait on nixpkgs to play.

## TL;DR

- Minecraft Bedrock auto-updates to a new version, the launcher is older, and the
  game segfaults on boot.
- Fix = bump **both** launcher packages in the overlay (version + tag + hash),
  rebuild, activate.
- Quick stopgap = install an older, non-beta game version via the launcher's
  Version dropdown.

## The moving parts

| Piece | Role | Lives in |
|-------|------|----------|
| `mcpelauncher-client` | The loader binary. Must understand the game's vtable/symbol layout. | overlay `overlays-mcpe.nix` |
| `mcpelauncher-ui-qt` | Qt GUI: downloads game versions, manages mods/profiles, spawns the client (its wrapper puts `mcpelauncher-client` on `PATH`). | overlay `overlays-mcpe.nix` |
| `mcpelauncher-updates` mod | Version-specific patches that adapt the game lib to the launcher. | `~/.local/share/mcpelauncher/mods/mcpelauncher-updates/<ver>/x86_64/` |
| version DB | Game versions still downloadable from Google Play (backing the Version dropdown). | `minecraft-linux/mcpelauncher-versiondb` |

The crash is almost always **client too old for the installed game version** —
not a bad world, profile, or install. **Do not delete your install/worlds.**

## 1. Recognise the symptom

In the client log you get a cluster like:

```
Info  [Launcher] Game version: 1.26.51.1
Debug [CorePatches] Failed to patch, vtable _ZTV21AppPlatform_android23 not found
Error [JniSupport] Missing native symbol: Java_com_mojang_minecraftpe_MainActivity_nativeRegisterThis
Signal 11 received
```

Rule of thumb: the game's series (`1.26.51` = "26.51") is newer than what the
launcher release notes mention supporting. The launcher also prints a generic
hint: *"Incompatible Minecraft installation, please select a different or older
Version"*.

## 2. Confirm the cause (3 reads)

```sh
# a) what game version crashed? (from the log / terminal output)
grep -E 'Game version:|Failed to patch|Signal 11' <log>

# b) is that version in the download DB? (also the downgrade list)
curl -s https://raw.githubusercontent.com/minecraft-linux/mcpelauncher-versiondb/master/versions.x86_64.json.min \
  | tr ']' '\n' | grep '1.26.51'

# c) what does nixpkgs ship right now? (is our overlay even needed?)
curl -s https://raw.githubusercontent.com/NixOS/nixpkgs/nixpkgs-unstable/pkgs/by-name/mc/mcpelauncher-client/package.nix \
  | grep -m1 version
```

Then read the upstream release notes to find a launcher tag that covers your
game series:

- Launcher: <https://github.com/minecraft-linux/mcpelauncher-manifest/releases>
- Updates mod: <https://github.com/minecraft-linux/mcpelauncher-updates/releases>

> Tip: the GUI's own config shows the latest Play version —
> `~/.config/Minecraft Linux Launcher/Minecraft Linux Launcher UI.conf` →
> `[googleversionchannel] latest_version=`.

## 3. Durable fix bump the overlay

Edit `juajar/sysjar/nix/overlays-mcpe.nix` and raise **both** packages to the
newest suitable tag (e.g. `1.8.4-qt6`): `version`, `tag`, and `hash`.

### 3a. Get the two recursive hashes

The manifests are aggregators with submodules, so `fetchSubmodules = true` and
the hash is the recursive tree hash. Let Nix compute it for you. Write
`/tmp/mcpe-hashes.nix`:

```nix
let
  flake = builtins.getFlake "/home/jar/nix-config";
  pkgs  = flake.inputs.nixpkgs.legacyPackages.x86_64-linux;
  lib   = pkgs.lib;
in {
  client = pkgs.fetchFromGitHub {
    owner = "minecraft-linux"; repo = "mcpelauncher-manifest";
    tag = "vTAG"; fetchSubmodules = true; hash = lib.fakeHash;
  };
  ui = pkgs.fetchFromGitHub {
    owner = "minecraft-linux"; repo = "mcpelauncher-ui-manifest";
    tag = "vTAG"; fetchSubmodules = true; hash = lib.fakeHash;
  };
}
```

```sh
nix build --impure --no-link --expr '(import /tmp/mcpe-hashes.nix).client'   # prints: got: sha256-…
nix build --impure --no-link --expr '(import /tmp/mcpe-hashes.nix).ui'       # prints: got: sha256-…
```

Paste each `got:` value into the matching `hash = "sha256-…";`.

### 3b. Build the package first (fast, no sudo)

Catches patch/eval failures before touching the system:

```sh
nix build --impure --no-link --print-out-paths \
  --expr '(builtins.getFlake "/home/jar/nix-config").nixosConfigurations.calender.pkgs.mcpelauncher-ui-qt'
```

### 3c. Build the system, then activate

```sh
nh os build  --accept-flake-config ~/nix-config#calender   # no sudo; shows the CHANGED diff
nh os switch --accept-flake-config ~/nix-config#calender   # sudo
```

`nh os build` should show only:

```
mcpelauncher-client   <old> -> <new>
mcpelauncher-ui-qt    <old> -> <new>
```

### 3d. Verify

1. Confirm the UI wrapper points at the new client:

   ```sh
   strings "$(dirname "$(readlink -f "$(command -v mcpelauncher-ui-qt)")")/mcpelauncher-ui-qt" \
     | grep -oE '/nix/store/[a-z0-9]+-mcpelauncher-client-[0-9][^ :"]*' | sort -u
   ```

2. Launch your game version; confirm the log reaches the main thread with **no
   `Signal 11`**. The updates mod may print `no patches applied` for very new
   versions that is expected, the newer client handles it.

### Rollback

```sh
git -C ~/nix-config checkout -- juajar/sysjar/nix/overlays-mcpe.nix
nh os switch --accept-flake-config ~/nix-config#calender
```

## 4. Stopgap fix downgrade the game (no rebuild)

Home screen → **pencil (Edit profile)** → **Version** dropdown → pick an older
**non-beta** entry (e.g. `1.26.45.1 (x86_64)`) → Save → Play becomes
**"Download and play"** and installs it from Google Play.

> [!WARNING]
> Bedrock is not backwards compatible for saves. A world last opened on a newer
> version may refuse to open on an older one. Prefer the launcher bump if you
> care about current worlds.

## 5. Gotchas that bite on the *next* bump

- **`--replace-fail` substitutions.** nixpkgs rewrites, in `postPatch`:
  `/usr/bin/xdg-open` and `/usr/bin/zenity` in
  `mcpelauncher-client/src/jni/main_activity.cpp`, and
  `EXECUTABLE_NAME = "zenity"` in
  `file-picker/src/file_picker_zenity.cpp`. If an upstream rewrite moves/renames
  these, the build fails loudly → override `postPatch` in the overlay.
- **Vendored patches.** `mcpe-patches/dont_download_glfw_client.patch` rewrites
  `ext/glfw.cmake`; `mcpe-patches/fix-cmake4-build.patch` bumps
  `cmake_minimum_required` in several submodules. If upstream changes those
  files, patch application fails → refresh the patch pre-images.
- **Two hashes, one tag.** Client and UI live in *different* repos
  (`mcpelauncher-manifest` vs `mcpelauncher-ui-manifest`) but share the same
  version string. Both must be bumped together.

## 6. When you can retire the overlay

When step 2c shows nixpkgs shipping a version ≥ the one you need, the
`version`/`src` overrides become redundant. The overlay's old extra purpose
(`curlWithWebsockets`) is already upstream, so `overlays-mcpe.nix` can likely be
deleted at that point re-check first.

## 7. Quick reference

| Thing | Value |
|-------|-------|
| Overlay | `juajar/sysjar/nix/overlays-mcpe.nix` |
| Patches | `juajar/sysjar/nix/mcpe-patches/` |
| UI config | `~/.config/Minecraft Linux Launcher/Minecraft Linux Launcher UI.conf` |
| Game data / mods | `~/.local/share/mcpelauncher/` |
| Version DB | <https://github.com/minecraft-linux/mcpelauncher-versiondb> |
| Launcher releases | <https://github.com/minecraft-linux/mcpelauncher-manifest/releases> |
| Updates mod releases | <https://github.com/minecraft-linux/mcpelauncher-updates/releases> |

Version code examples (x86_64): `982604501` = 1.26.45.1, `982605101` = 1.26.51.1.
