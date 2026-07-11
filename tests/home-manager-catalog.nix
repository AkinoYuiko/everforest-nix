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
  catalog = import ../modules/home-manager/application-theme-catalog.nix { inherit lib; };

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

  linuxConfiguration = mkHomeConfiguration linuxPkgs {
    everforest.hyprland.enable = true;
  };

  darwinConfiguration = mkHomeConfiguration darwinPkgs {
    everforest.bat.enable = true;
    everforest.hyprland.enable = true;
  };

  linuxCatalog = catalog.forHostPlatform linuxPkgs.stdenv.hostPlatform;
  darwinCatalog = catalog.forHostPlatform darwinPkgs.stdenv.hostPlatform;
  linuxNames = map (entry: entry.name) linuxCatalog.eligible;
  darwinNames = map (entry: entry.name) darwinCatalog.eligible;

  expectedLinuxNames = [
    "tofi"
    "rofi"
    "yazi"
    "chrome"
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
    "chrome"
    "bat"
    "helix"
    "ghostty"
    "fzf"
    "starship"
    "opencode"
  ];

  testFile = ./home-manager-catalog.nix;
  validEntry = {
    name = "valid";
    file = testFile;
    platforms = [ "linux" ];
  };

  validationSucceeds =
    entries: (builtins.tryEval (builtins.deepSeq (catalog.validate entries) true)).success;

  unsupportedPlatform = builtins.tryEval (
    builtins.deepSeq (catalog.forHostPlatform {
      isLinux = false;
      isDarwin = false;
      system = "x86_64-freebsd";
    }) true
  );
in
assert linuxConfiguration.options.everforest ? hyprland;
assert linuxConfiguration.config.everforest.hyprland.enable;
assert darwinConfiguration.options.everforest ? hyprland;
assert darwinConfiguration.config.everforest.bat.enable;
assert !darwinConfiguration.config.everforest.hyprland.enable;
assert builtins.length catalog.entries == 16;
assert lib.sort builtins.lessThan linuxNames == lib.sort builtins.lessThan expectedLinuxNames;
assert lib.sort builtins.lessThan darwinNames == lib.sort builtins.lessThan expectedDarwinNames;
assert !unsupportedPlatform.success;
assert validationSucceeds [ validEntry ];
assert
  !(validationSucceeds [
    validEntry
    (validEntry // { platforms = [ "darwin" ]; })
  ]);
assert !(validationSucceeds [ (builtins.removeAttrs validEntry [ "name" ]) ]);
assert !(validationSucceeds [ (validEntry // { platforms = [ ]; }) ]);
assert !(validationSucceeds [ (validEntry // { platforms = [ "freebsd" ]; }) ]);
assert
  !(validationSucceeds [
    (validEntry // { file = builtins.toPath "/everforest-missing-theme.nix"; })
  ]);
checkPkgs.runCommand "everforest-home-manager-catalog" { } ''
  touch "$out"
''
