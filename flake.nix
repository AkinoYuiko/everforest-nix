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
  outputs = { self, nixpkgs, home-manager }:
  let
    inherit (nixpkgs) lib;
    systems = lib.systems.flakeExposed;
    forAllSystems = lib.genAttrs systems;
    mkModule = { name ? "everforest", type, file }:{ pkgs, ... }:{
      _file = "${self.outPath}/flake.nix#${type}Modules.${name}";
      imports = [ file ];
    };
  in {
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);
    checks = forAllSystems (system: {
      home-manager-catalog = import ./tests/home-manager-catalog.nix {
        inherit self nixpkgs home-manager system;
      };
      home-manager-enablement = import ./tests/home-manager-enablement.nix {
        inherit self nixpkgs home-manager system;
      };
    });
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
