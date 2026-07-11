{
  self,
  nixpkgs,
  home-manager,
  system,
}:
let
  lib = nixpkgs.lib;
  checkPkgs = nixpkgs.legacyPackages.${system};
  linuxPkgs = nixpkgs.legacyPackages.x86_64-linux;
  darwinPkgs = nixpkgs.legacyPackages.aarch64-darwin;

  expectedApplicationThemes = [
    {
      name = "tofi";
      platforms = [ "linux" ];
    }
    {
      name = "rofi";
      platforms = [ "linux" ];
    }
    {
      name = "yazi";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "brave";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "chromium";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "vivaldi";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "bat";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "waybar";
      platforms = [ "linux" ];
    }
    {
      name = "hyprland";
      platforms = [ "linux" ];
    }
    {
      name = "hyprlock";
      platforms = [ "linux" ];
    }
    {
      name = "helix";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "ghostty";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "zathura";
      platforms = [ "linux" ];
    }
    {
      name = "fzf";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "starship";
      platforms = [
        "linux"
        "darwin"
      ];
    }
    {
      name = "cursor";
      platforms = [ "linux" ];
    }
    {
      name = "gtk";
      platforms = [ "linux" ];
    }
    {
      name = "opencode";
      platforms = [
        "linux"
        "darwin"
      ];
    }
  ];

  expectedNamesFor =
    platform:
    map (theme: theme.name) (
      builtins.filter (theme: builtins.elem platform theme.platforms) expectedApplicationThemes
    );

  expectedApplicationThemeNames = map (theme: theme.name) expectedApplicationThemes;
  expectedLinuxNames = expectedNamesFor "linux";
  expectedDarwinNames = expectedNamesFor "darwin";

  mkHomeConfiguration =
    pkgs: module:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        self.homeModules.everforest
        {
          home = {
            username = "everforest-test";
            homeDirectory =
              if pkgs.stdenv.hostPlatform.isDarwin then "/Users/everforest-test" else "/home/everforest-test";
            stateVersion = "24.11";
          };
        }
        module
      ];
    };

  enableAllThemes = {
    everforest = lib.genAttrs expectedApplicationThemeNames (_: {
      enable = true;
    });
  };

  linuxConfiguration = mkHomeConfiguration linuxPkgs enableAllThemes;
  darwinConfiguration = mkHomeConfiguration darwinPkgs enableAllThemes;

  applicationThemeOptionNames =
    configuration:
    builtins.filter (
      name:
      !(builtins.elem name [
        "enable"
        "palette"
      ])
    ) (builtins.attrNames configuration.options.everforest);
  enabledApplicationThemeNames =
    configuration:
    builtins.filter (
      name: configuration.config.everforest.${name}.enable
    ) expectedApplicationThemeNames;

  unsupportedPlatform = builtins.tryEval (
    builtins.deepSeq (mkHomeConfiguration nixpkgs.legacyPackages.x86_64-freebsd { }).config.everforest
      true
  );
in
assert
  lib.sort builtins.lessThan (applicationThemeOptionNames linuxConfiguration)
  == lib.sort builtins.lessThan expectedApplicationThemeNames;
assert
  lib.sort builtins.lessThan (applicationThemeOptionNames darwinConfiguration)
  == lib.sort builtins.lessThan expectedApplicationThemeNames;
assert
  lib.sort builtins.lessThan (enabledApplicationThemeNames linuxConfiguration)
  == lib.sort builtins.lessThan expectedLinuxNames;
assert
  lib.sort builtins.lessThan (enabledApplicationThemeNames darwinConfiguration)
  == lib.sort builtins.lessThan expectedDarwinNames;
assert !unsupportedPlatform.success;
checkPkgs.runCommand "everforest-home-manager-catalog" { } ''
  touch "$out"
''
