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

  expectedLinuxNames = [
    "tofi"
    "rofi"
    "yazi"
    "chromium"
    "brave"
    "vivaldi"
    "bat"
    "waybar"
    "hyprland"
    "hyprlock"
    "helix"
    "ghostty"
    "zathura"
    "fzf"
    "starship"
    "cursor"
    "gtk"
    "opencode"
  ];

  expectedDarwinNames = [
    "yazi"
    "chromium"
    "brave"
    "vivaldi"
    "bat"
    "helix"
    "ghostty"
    "fzf"
    "starship"
    "opencode"
  ];

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
    everforest = lib.genAttrs expectedLinuxNames (_: {
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
    builtins.filter (name: configuration.config.everforest.${name}.enable) expectedLinuxNames;

  unsupportedPlatform = builtins.tryEval (
    builtins.deepSeq (mkHomeConfiguration nixpkgs.legacyPackages.x86_64-freebsd { }).config.everforest
      true
  );
in
assert
  lib.sort builtins.lessThan (applicationThemeOptionNames linuxConfiguration)
  == lib.sort builtins.lessThan expectedLinuxNames;
assert
  lib.sort builtins.lessThan (applicationThemeOptionNames darwinConfiguration)
  == lib.sort builtins.lessThan expectedLinuxNames;
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
