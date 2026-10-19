**Links:**
- [Back Home](../../README.md)
- [Documentation Key](./key-key.md)

---

# Docs Guide

How these docs are meant to be written, so they stay useful without being
maintained after every config change.

## The rule

**Docs explain why. Code is the source of truth.**

If a fact lives in the config, don't copy it here. Point at it. A doc that
enumerates modules, keybinds, model lists, or hex values will be wrong the next
time the code moves, and nobody re-reads docs to fix them. Docs that teach a
concept or a procedure outlive the code.

## What belongs where

- **Learning** — the "why" and "how to think about it" (Nix, modules, PipeWire,
  sysadmin habits). Written once, rarely changes.
- **Procedure** — steps to get somewhere (install, add a host, migrate a server).
  Keep steps, but never embed lists that live in the tree. Tell the reader how to
  look (`ls hstjar/`).
- **Reference** — indexes that help you navigate. Keep them thin; they point at
  code, they don't restate it.

## Style

- Short and direct. One idea per paragraph.
- Plain language, lowercase headers are fine.
- Every doc starts with the two links at the top (Back Home + Documentation Key).
- Link paths are relative to the doc's own location.
- No status boards or checkboxes (those live in git history).
- When in doubt, cut it.

## When to add a doc

Add one when the knowledge is *not obvious from reading the code* — a concept,
a gotcha, a procedure with ordering. Otherwise a code comment is enough.
