# Everforest for Nix

Everforest theme for almost everything in Nix, heavily inspired by the [Catppuccin's Nix repo](https://github.com/catppuccin/nix).

Currently, it only supports the dark variant and the hard contrast.

The Everforest theme's palette is also available under the `everforest.palette` attribute, for use in your own configuration (see the examples below).

<details>
<summary>Supported apps:</summary>

- [x] hyprland (you have to choose the colors in your own waybar config)
- [ ] zen browser
- [x] ghostty
- [x] vivaldi
- [x] chromium
- [x] brave
- [x] tty
- [x] waybar (you have to choose the colors in your own waybar config)
- [x] helix
- [x] bat
- [x] fzf
- [x] zathura
- [ ] btop
- [ ] onlyoffice
- [x] rofi (you have to choose the colors in your own rofi config)
- [x] yazi
- [x] starship
- [ ] firefox
- [x] gtk
- [ ] swaync-client
- [x] hyprlock (you have to choose the colors in your own rofi config)
- [x] cursor
- [x] tofi
- [x] opencode
- [ ] heroic games launcher
- [ ] spotify-client
- [ ] much more...
</details>

## Instalation

### 1. _flake.nix_

First, you need to include _everforest-nix_ in the inputs of your _flake.nix_ file.

```nix
{
  description = <your code>;
  inputs = {
    <your code>
    everforest.url = "git+https://codeberg.org/fwinter/everforest-nix.git"; # add everforest module to inputs.
  };
  outputs = { self, nixpkgs, }@inputs:
  {
    nixosConfigurations.<your hostname> = nixpkgs.lib.nixosSystem {
      <your code>
      modules = [
        <your code>
        everforest.nixosModules.everforest # add everforest module to nix configuration.
        inputs.home-manager.nixosModules.home-manager {
          <your code>
          imports = [
            ./home.nix
            everforest.homeModules.everforest # add everforest module to home-manager.
          ];
        };
      ];
    }
  }
}
```

### 2. _home.nix_ and _configuration.nix_ (both)

Then, you need to configure _home.nix_ and _configuration.nix_, enabling the _everforest-nix_ module.

```nix
{ pkgs, config, ... }:
{
  <your code>
  gtk.enable = true; # to enable the cursor theme on gtk apps
  everforest.enable = true;
}
```

### 3. Update

Finally, update your flake and switch to the new configuration.

## Usage

### Enablement

`everforest.enable` sets the default for every Application Theme, but it does not enable target applications. A theme is applied only when both the Application Theme and its target application are enabled.

```nix
{
  everforest.enable = true;
  programs.ghostty.enable = true;

  # Explicit per-theme settings override the global default.
  everforest.bat.enable = false;
}
```

You can also enable one Application Theme without enabling Everforest globally:

```nix
{
  everforest.ghostty.enable = true;
  programs.ghostty.enable = true;
}
```

When upgrading from an older revision, note that Application Themes no longer default to enabled when `everforest.enable` is false or unset. Set `everforest.enable = true` or explicitly enable the individual themes you want.

The Home Manager module supports Linux and Darwin. All Application Theme options are visible on both platforms, but the Home Manager Application Theme Catalog forces platform-ineligible themes off; for example, explicitly enabling a Linux-only theme on Darwin has no effect.

<details>
<summary>Click here to see the palette</summary>

The palette is an attribute set, as following:

```nix
{
  bg_dim = "#1E2326";
  bg0 = "#272E33";
  bg1 = "#2E383C";
  bg2 = "#374145";
  bg3 = "#414B50";
  bg4 = "#495156";
  bg5 = "#4F5B58";
  bg_visual = "#4C3743";
  bg_red = "#493B40";
  bg_green = "#3C4841";
  bg_blue = "#384B55";
  bg_yellow = "#45443C";
  bg_purple = "#463F48";
  fg = "#D3C6AA";
  red = "#E67E80";
  orange = "#E69875";
  yellow = "#DBBC7F";
  green = "#A7C080";
  aqua = "#83C092";
  blue = "#7FBBB3";
  purple = "#D699B6";
  grey0 = "#7A8478";
  grey1 = "#859289";
  grey2 = "#9DA9A0";
  statusline1 = "#A7C080";
  statusline2 = "#D3C6AA";
  statusline3 = "#E67E80";
}
```

</details>

### Examples

<details>
<summary>Hyprland</summary>

```nix
{
  <your code>
  wayland.windowManager.hyprland.settings = {
    <your code>
    general = {
      <your code>
      "col.active_border" = "$green";
      "col.inactive_border" = "$bg3";
    };
  };
}
```

</details>

<details>
<summary>Waybar</summary>

```nix
{
  <your code>
  programs.waybar.style = ''
    <your code>
     tooltip = {
      <your code>
      background = @bg_dim;
    }
  ''
}
```

</details>

<details>
<summary>Rofi</summary>

```nix
{ config, ... }:{
  <your code>
  programs.rofi.theme = {
    <your code>
    window = {
      <your code>
      background-color = config.lib.formats.rasi.mkLiteral "@bg0";
    };
  };
}
```

</details>

## Acknowledgements to other projects

We use other projects for some of the apps, so big thanks to them!

- [everforest-cursors](https://github.com/talwat/everforest-cursors) by [talwat](https://github.com/talwat)
- [everforest-chrome](https://github.com/thmatosbr/everforest-chrome) by [thmatosbr](https://github.com/thmatosbr)
- [Everforest-GTK-Theme](https://github.com/Fausto-Korpsvart/Everforest-GTK-Theme) by [Fausto-Korpsvart](https://github.com/Fausto-Korpsvart)
- [everforest-medium.yazi](https://github.com/Chromium-3-Oxide/everforest-medium.yazi) by [Chromium-3-Oxide](https://github.com/Chromium-3-Oxide)
