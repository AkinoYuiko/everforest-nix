# ███████╗██╗   ██╗███████╗██████╗ ███████╗ ██████╗ ██████╗ ███████╗███████╗████████╗
# ██╔════╝██║   ██║██╔════╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗██╔════╝██╔════╝╚══██╔══╝
# █████╗  ██║   ██║█████╗  ██████╔╝█████╗  ██║   ██║██████╔╝█████╗  ███████╗   ██║
# ██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██╔══██╗██╔══╝  ╚════██║   ██║
# ███████╗ ╚████╔╝ ███████╗██║  ██║██║     ╚██████╔╝██║  ██║███████╗███████║   ██║
# ╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝
# https://codeberg.org/fwinter/everforest-nix

{
  description = "Everforest theme for Nix";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }:
    let
      inherit (nixpkgs) lib;
      systems = lib.systems.flakeExposed;
      forAllSystems = lib.genAttrs systems;
      mkModule =
        {
          name ? "everforest",
          type,
          file,
        }:
        { pkgs, ... }: {
          _file = "${self.outPath}/flake.nix#${type}Modules.${name}";
          imports = [ file ];
        };
    in
    {
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
      apps = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          checkUpstreamPalette = pkgs.writeShellApplication {
            name = "check-upstream-palette";
            runtimeInputs = [
              pkgs.coreutils
              pkgs.curl
              pkgs.python3
            ];
            text = ''
              export EVERFOREST_REPO_ROOT=${self}
              exec ${pkgs.runtimeShell} ${./scripts/check-upstream-palette} "$@"
            '';
          };
        in
        {
          check-upstream-palette = {
            type = "app";
            program = "${checkUpstreamPalette}/bin/check-upstream-palette";
            meta.description = "Compare the local dark hard palette with sainnhe/everforest";
          };
        }
      );
      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          home-manager-catalog = import ./tests/home-manager-catalog.nix {
            inherit
              self
              nixpkgs
              home-manager
              system
              ;
          };
          home-manager-enablement = import ./tests/home-manager-enablement.nix {
            inherit
              self
              nixpkgs
              home-manager
              system
              ;
          };
          home-manager-opencode = import ./tests/home-manager-opencode.nix {
            inherit
              self
              nixpkgs
              home-manager
              system
              ;
          };
          palette-dark-hard = import ./tests/palette-dark-hard.nix {
            inherit nixpkgs system;
          };
        }
        // lib.optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
          home-manager-hypr-rendering = import ./tests/home-manager-hypr-rendering.nix {
            inherit
              self
              nixpkgs
              home-manager
              system
              ;
          };
        }
      );
      homeModules = {
        default = self.homeModules.everforest;
        everforest = mkModule {
          type = "homeManager";
          file = ./modules/home-manager;
        };
      };
      nixosModules = {
        default = self.nixosModules.everforest;
        everforest = mkModule {
          type = "nixos";
          file = ./modules/nixos;
        };
      };
    };
}
