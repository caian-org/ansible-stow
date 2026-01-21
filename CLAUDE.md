# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

ansible-stow is an Ansible module that wraps GNU Stow for managing symlink farms. It's a single-file module (`stow`) that enables idempotent dotfile/package management in Ansible playbooks.

## Commands

**Install dependencies:**
```bash
uv sync --extra dev
```

**Code quality checks:**
```bash
uv run poe check:style      # Black formatting check (120 char lines)
uv run poe check:lint       # PyLint (must score >= 9)
uv run poe check:security   # Bandit security scan
uv run poe check:deadcode   # Vulture dead code detection
```

**Fix formatting:**
```bash
uv run poe fix:style
```

**Run tests:**
```bash
cd tests && ./test.sh
```

Tests run an Ansible playbook that exercises module states (present, absent, latest, supress) and verifies symlink operations.

## Architecture

- **`stow.py`** - The entire module in one executable Python script (~320 lines). Uses Ansible's `AnsibleModule` base class. Distributed as `stow.py` but invoked as `stow` in playbooks.
- **`tests/`** - Integration tests via `test.sh` that runs `stow.yml` playbook against test packages in `package/`.

**Key module functions:**
- `purge_conflicts()` - Removes conflicting files/symlinks for `supress` state
- `stow_has_conflicts()` - Detects conflicts via dry-run
- `has_stow_changed_links()` - Parses stow output to detect changes (handles Stow 2.3.1 vs 2.4.0 output differences)
- `stow()` - Core execution logic

**Module states:**
- `present` - Stow packages (creates symlinks)
- `absent` - Unstow packages (removes symlinks)
- `latest` - Restow (unstow then stow)
- `supress` - Stow with conflict overwrite (deletes conflicting files first)

## Code Style

- Black formatter with 120-char line limit, no string normalization (`-l 120 -S`)
- PyLint minimum score: 9.0
- Docstrings not required (disabled in .pylintrc)
- Development requires Python >= 3.10; runtime supports Python 3.6+
