# emacs.d

A modular Emacs configuration centered around a small `init.el`, focused
module files in `lisp/`, and a local/private override layer that stays out of
version control.

## Highlights

- Modular startup layout with focused `init-*.el` files
- Local state and generated files ignored via `.gitignore`
- LaTeX, Lisp, YAML, AI tooling, and editing helpers split into separate modules
- A small `~/.emacs` bootstrap that prefers newer source files and recompiles
  the config when needed

## Layout

```text
.
├── init.el
├── lisp/
│   ├── init-packages.el
│   ├── init-core.el
│   ├── init-ai.el
│   ├── init-languages.el
│   ├── init-tex.el
│   ├── init-lisp.el
│   ├── init-yaml.el
│   ├── init-editing.el
│   ├── init-compat.el
│   └── init-local.el.example
└── wordle/
```

## Module Guide

- `init.el`: top-level loader
- `lisp/init-packages.el`: package archives and `use-package`
- `lisp/init-core.el`: core Emacs behavior, desktop/session, frame setup, Magit menu
- `lisp/init-ai.el`: `gptel` setup and repo-context helpers
- `lisp/init-languages.el`: language modes outside TeX/Lisp/YAML
- `lisp/init-tex.el`: AUCTeX, RefTeX, and LaTeX-specific setup
- `lisp/init-lisp.el`: SLY and Common Lisp workflow
- `lisp/init-yaml.el`: YAML and LSP configuration
- `lisp/init-editing.el`: completion, snippets, whitespace, spelling behavior
- `lisp/init-compat.el`: byte-compiler declarations and compatibility glue
- `lisp/init-local.el.example`: template for local machine-specific overrides

## Local Overrides

Private or machine-specific settings belong in:

```elisp
~/.emacs.d/lisp/init-local.el
```

That file is optional and loaded automatically if present.

## Bootstrap

This repo is meant to be loaded from `~/.emacs`, which:

- sets `PATH` and a few machine-local basics
- enables `load-prefer-newer`
- recompiles the init modules when needed
- loads `init.el`
- loads `custom.el` if it exists

## Recompile

Inside Emacs:

```elisp
M-x rb/byte-compile-init-files
```

Default keybinding:

```text
C-c e c
```

## Notes

- `custom.el` is intentionally not versioned
- package installs and cache/state directories are ignored
- this repo tracks the config itself, not the generated environment around it
