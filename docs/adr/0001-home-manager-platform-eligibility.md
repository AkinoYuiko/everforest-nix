---
status: accepted
---

# Enforce Home Manager platform eligibility after static imports

Home Manager module imports cannot depend on `pkgs` supplied through `_module.args` without causing infinite recursion. We therefore keep `homeModules.everforest` as the single public module, statically import every Home Manager Application Theme, and use the Home Manager Application Theme Catalog during configuration evaluation to force platform-ineligible themes off.

## Considered options

- **Conditional imports based on `pkgs`** were rejected because Nix must resolve imports before `_module.args.pkgs` is available.
- **Separate Linux and Darwin public modules** were rejected because callers would have to own platform-selection knowledge and the public interface would grow.
- **A required platform special argument** was rejected because it would make ordinary module imports more complicated and easier to misconfigure.

## Consequences

- Linux and Darwin callers continue to import `homeModules.everforest` in the same way.
- All Application Theme options are visible on both supported platforms, but ineligible themes are forced to `enable = false` and cannot be explicitly enabled.
- Platform eligibility is declared once in the Home Manager Application Theme Catalog: all 16 current themes are eligible on Linux and 8 are eligible on Darwin.
- Platforms other than Linux and Darwin fail evaluation explicitly.
