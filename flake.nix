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
  };
  outputs = { self, nixpkgs }:
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
