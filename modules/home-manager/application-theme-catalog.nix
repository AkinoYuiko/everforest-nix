{ lib }:
let
  supportedPlatforms = [
    "linux"
    "darwin"
  ];

  catalogEntries = [
    {
      name = "tofi";
      file = ./tofi.nix;
      platforms = [ "linux" ];
    }
    {
      name = "rofi";
      file = ./rofi.nix;
      platforms = [ "linux" ];
    }
    {
      name = "yazi";
      file = ./yazi.nix;
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "chrome";
      file = ./chrome.nix;
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "bat";
      file = ./bat.nix;
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "waybar";
      file = ./waybar.nix;
      platforms = [ "linux" ];
    }
    {
      name = "hyprland";
      file = ./hyprland.nix;
      platforms = [ "linux" ];
    }
    {
      name = "hyprlock";
      file = ./hyprlock.nix;
      platforms = [ "linux" ];
    }
    {
      name = "helix";
      file = ./helix.nix;
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "ghostty";
      file = ./ghostty.nix;
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "zathura";
      file = ./zathura.nix;
      platforms = [ "linux" ];
    }
    {
      name = "fzf";
      file = ./fzf.nix;
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "starship";
      file = ./starship.nix;
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "cursor";
      file = ./cursor.nix;
      platforms = [ "linux" ];
    }
    {
      name = "gtk";
      file = ./gtk.nix;
      platforms = [ "linux" ];
    }
    {
      name = "opencode";
      file = ./opencode.nix;
      platforms = [
        "linux"
        "darwin"
      ];
    }
  ];

  fail = message: throw "Invalid Home Manager Application Theme Catalog: ${message}";

  validateEntry =
    entry:
    let
      label =
        if builtins.isAttrs entry && entry ? name && builtins.isString entry.name then
          "`${entry.name}`"
        else
          "<unnamed>";
      unknownPlatforms =
        if builtins.isAttrs entry && entry ? platforms && builtins.isList entry.platforms then
          builtins.filter (platform: !(builtins.elem platform supportedPlatforms)) entry.platforms
        else
          [ ];
    in
    if !builtins.isAttrs entry then
      fail "each entry must be an attribute set"
    else if !(entry ? name) || !builtins.isString entry.name || entry.name == "" then
      fail "${label} must have a non-empty string `name`"
    else if !(entry ? file) || !builtins.isPath entry.file then
      fail "${label} must have a path-valued `file`"
    else if !builtins.pathExists entry.file then
      fail "${label} references a missing module file"
    else if !(entry ? platforms) || !builtins.isList entry.platforms || entry.platforms == [ ] then
      fail "${label} must have at least one platform"
    else if !builtins.all builtins.isString entry.platforms then
      fail "${label} platforms must be strings"
    else if unknownPlatforms != [ ] then
      fail "${label} uses unsupported platforms: ${builtins.concatStringsSep ", " unknownPlatforms}"
    else
      entry;

  validate =
    entries:
    let
      validatedEntries = map validateEntry entries;
      names = map (entry: entry.name) validatedEntries;
      duplicateNames = lib.unique (
        builtins.filter (
          name: builtins.length (builtins.filter (candidate: candidate == name) names) > 1
        ) names
      );
    in
    if !builtins.isList entries then
      fail "catalog must be a list"
    else if duplicateNames != [ ] then
      fail "duplicate names: ${builtins.concatStringsSep ", " duplicateNames}"
    else
      validatedEntries;

  entries = validate catalogEntries;

  platformName =
    hostPlatform:
    if hostPlatform.isLinux then
      "linux"
    else if hostPlatform.isDarwin then
      "darwin"
    else
      throw "everforest Home Manager module supports Linux and Darwin only; got `${hostPlatform.system}`";
in
{
  inherit entries validate;

  moduleFiles = map (entry: entry.file) entries;

  forHostPlatform =
    hostPlatform:
    let
      platform = platformName hostPlatform;
    in
    {
      eligible = builtins.filter (entry: builtins.elem platform entry.platforms) entries;
      ineligible = builtins.filter (entry: !(builtins.elem platform entry.platforms)) entries;
    };
}
