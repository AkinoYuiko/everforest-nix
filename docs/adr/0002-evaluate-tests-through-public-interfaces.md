---
status: accepted
---

# Evaluate tests through public interfaces

Repository tests must validate observable behavior through public interfaces. `nix flake check` is the single entry point for reproducible tests of the repository state.

Home Manager Application Theme tests therefore evaluate real `home-manager.lib.homeManagerConfiguration` values and assert on the resulting public configuration. Tests must not read module source text to verify implementation details such as variable names, `inherit` expressions, or the presence or absence of hard-coded strings.

The Dark Hard Palette is itself an importable data interface, so its contract is tested by comparing the complete exported attribute set with the expected palette. Application Theme tests may derive their expected colors from that interface and separately verify the configuration exposed by Home Manager.

## Considered options

- **Source-text tests** were rejected because equivalent implementation changes can break them without changing behavior, while incorrect evaluated behavior can escape detection.
- **Tests that import private module internals** were rejected because they couple the suite to repository representation rather than the public module contract.
- **Generated-file text snapshots** were rejected where evaluated configuration provides a more direct interface, because serialization and formatting are not generally part of the intended contract.
- **Running the live upstream Palette comparison in `nix flake check`** was rejected because network availability and upstream branch movement would make otherwise unchanged repository revisions fail nondeterministically.

## Consequences

- Palette, Home Manager Application Theme Catalog behavior, enablement policy, and OpenCode theme behavior are all evaluated by flake checks.
- OpenCode tests verify its complete theme definitions and semantic mappings without requiring a particular module implementation.
- The implementation-coupled OpenCode source-text test is removed.
- Developers can compare the local Dark Hard Palette with the latest or a specified revision of `sainnhe/everforest` through `nix run .#check-upstream-palette`, but this network-dependent drift check remains outside the default test suite.
- Palette rendering concerns, including duplicated Hyprland or ANSI rendering logic, remain separate architectural work.
