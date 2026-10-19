**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Coloring

Pseudo-Gruvbox: warm, dark, orange accent. One palette drives everything.

**Source of truth:** [`juajar/liijar/theming/palette.nix`](../../juajar/liijar/theming/palette.nix).
Every app module reads the derived `usrset.theming.colors` — never hardcode a
hex, edit the palette. Restart/rebuild to see the change.

The derived colors cover backgrounds (`bg0`–`bg4`), foregrounds (`fg0`–`fg2`),
`grey`, and `accent` / `accent bright`. Names are stable; values come from the
palette file.
