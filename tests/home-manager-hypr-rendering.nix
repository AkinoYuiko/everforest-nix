{
  self,
  nixpkgs,
  home-manager,
  system,
}:
let
  pkgs = nixpkgs.legacyPackages.${system};

  configuration = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      self.homeModules.everforest
      {
        home = {
          username = "everforest-test";
          homeDirectory = "/home/everforest-test";
          stateVersion = "24.11";
        };
        everforest = {
          hyprland.enable = true;
          hyprlock.enable = true;
        };
        wayland.windowManager.hyprland = {
          enable = true;
          configType = "hyprlang";
        };
        programs.hyprlock.enable = true;
      }
    ];
  };

  hyprlandSource = builtins.head configuration.config.wayland.windowManager.hyprland.settings.source;
  hyprlockSource = builtins.head configuration.config.programs.hyprlock.settings.source;

  expected = pkgs.writeText "expected-everforest-hypr-palette.conf" (
    builtins.concatStringsSep "\n" [
      "$aqua = rgb(83C092)"
      "$bg0 = rgb(272E33)"
      "$bg1 = rgb(2E383C)"
      "$bg2 = rgb(374145)"
      "$bg3 = rgb(414B50)"
      "$bg4 = rgb(495156)"
      "$bg5 = rgb(4F5B58)"
      "$bg_blue = rgb(384B55)"
      "$bg_dim = rgb(1E2326)"
      "$bg_green = rgb(3C4841)"
      "$bg_purple = rgb(463F48)"
      "$bg_red = rgb(493B40)"
      "$bg_visual = rgb(4C3743)"
      "$bg_yellow = rgb(45443C)"
      "$blue = rgb(7FBBB3)"
      "$fg = rgb(D3C6AA)"
      "$green = rgb(A7C080)"
      "$grey0 = rgb(7A8478)"
      "$grey1 = rgb(859289)"
      "$grey2 = rgb(9DA9A0)"
      "$orange = rgb(E69875)"
      "$purple = rgb(D699B6)"
      "$red = rgb(E67E80)"
      "$statusline1 = rgb(A7C080)"
      "$statusline2 = rgb(D3C6AA)"
      "$statusline3 = rgb(E67E80)"
      "$yellow = rgb(DBBC7F)"
    ]
  );
in
pkgs.runCommand "everforest-home-manager-hypr-rendering" { } ''
  diff -u ${expected} ${hyprlandSource}
  diff -u ${expected} ${hyprlockSource}
  touch "$out"
''
