**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Dev Notes & Learning

Notes from building this config. Not a status board (git history is), just the
lessons and the habits that made NixOS click.

## Current focus

- thinning the docs so they teach instead of track
- keeping hosts reproducible from `0_TEMPLATE`
- learning something new each time a rebuild surprises me

## Lessons

- **Read the error, all of it.** Nix tells you the exact option, file, and line.
  Skipping the stack trace is how you end up guessing.
- **One change, one rebuild.** Batch unrelated edits and you lose the thread when
  something breaks.
- **Test before you switch.** `nh os test` (or `nht`) builds and activates without
  making it the boot default. Cheap insurance.
- **The module system is just functions.** An option is declared once, set
  anywhere, read from `config`. Most confusion is two modules fighting over the
  same option.
- **`lib.mkIf` gates, `//` doesn't.** Merging attrsets with `//` silently drops
  earlier keys; use `mkMerge` when composing gated pieces.
- **The store is immutable.** If an app needs to write its own config, it can't
  live as a read-only symlink; give it a real path.
- **Generations are your undo.** Every switch is a new generation; you can boot
  any of them. `nh clean all --keep 7` keeps it tidy.
- **Reproduce, don't repair.** If a fix isn't in the config, it's not a fix, it's
  a memory.

## Habits worth stealing

- keep a `0_TEMPLATE` and scaffold hosts rather than hand-copying
- put secrets out of git and out of the store (see [Secrets](./secrets.md))
- let the bootloader hold multiple generations before you trust a change
- when something is fragile, document the *why* next to it, not the *what*
