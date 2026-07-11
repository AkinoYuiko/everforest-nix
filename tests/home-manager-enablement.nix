{
  self,
  nixpkgs,
  home-manager,
  system,
}:
let
  checkPkgs = nixpkgs.legacyPackages.${system};

  mkHomeConfiguration =
    testSystem: module:
    let
      pkgs = nixpkgs.legacyPackages.${testSystem};
    in
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

  hasBatTheme = configuration: configuration.config.xdg.configFile ? "bat/themes/everforest.tmTheme";

  globalDisabled = mkHomeConfiguration "aarch64-darwin" {
    programs.bat.enable = true;
  };

  globalEnabled = mkHomeConfiguration "aarch64-darwin" {
    everforest.enable = true;
    programs.bat.enable = true;
  };

  explicitlyEnabled = mkHomeConfiguration "aarch64-darwin" {
    everforest.bat.enable = true;
    programs.bat.enable = true;
  };

  explicitlyDisabled = mkHomeConfiguration "aarch64-darwin" {
    everforest.enable = true;
    everforest.bat.enable = false;
    programs.bat.enable = true;
  };

  targetDisabled = mkHomeConfiguration "aarch64-darwin" {
    everforest.enable = true;
    programs.bat.enable = false;
  };

  browserGeneratedOptions = mkHomeConfiguration "x86_64-linux" {
    everforest.chromium.enable = true;
    programs.chromium.enable = true;
  };

  ttyGlobalDisabled = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.everforest
      { system.stateVersion = "24.11"; }
    ];
  };

  ttyGlobalEnabled = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.nixosModules.everforest
      {
        system.stateVersion = "24.11";
        everforest.enable = true;
      }
    ];
  };
in
assert !globalDisabled.config.everforest.bat.enable;
assert !(hasBatTheme globalDisabled);
assert globalEnabled.config.everforest.bat.enable;
assert hasBatTheme globalEnabled;
assert explicitlyEnabled.config.everforest.bat.enable;
assert hasBatTheme explicitlyEnabled;
assert !explicitlyDisabled.config.everforest.bat.enable;
assert !(hasBatTheme explicitlyDisabled);
assert targetDisabled.config.everforest.bat.enable;
assert !targetDisabled.config.programs.bat.enable;
assert !(hasBatTheme targetDisabled);
assert browserGeneratedOptions.config.everforest.chromium.enable;
assert !browserGeneratedOptions.config.everforest.brave.enable;
assert !browserGeneratedOptions.config.everforest.vivaldi.enable;
assert builtins.length browserGeneratedOptions.config.programs.chromium.extensions == 1;
assert !ttyGlobalDisabled.config.everforest.tty.enable;
assert ttyGlobalEnabled.config.everforest.tty.enable;
assert builtins.length ttyGlobalEnabled.config.console.colors == 16;
checkPkgs.runCommand "everforest-home-manager-enablement" { } ''
  touch "$out"
''
