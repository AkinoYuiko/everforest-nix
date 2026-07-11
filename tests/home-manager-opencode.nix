{
  self,
  nixpkgs,
  home-manager,
  system,
}:
let
  pkgs = nixpkgs.legacyPackages.${system};
  palette = import ../palette;

  mkHomeConfiguration =
    module:
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
        {
          everforest.opencode.enable = true;
          programs.opencode.enable = true;
        }
        module
      ];
    };

  defaultConfiguration = mkHomeConfiguration { };
  transparentConfiguration = mkHomeConfiguration {
    everforest.opencode.transparentBackground = true;
  };

  themeName = "everforest-dark-hard";
  defaultTheme = defaultConfiguration.config.programs.opencode.themes.${themeName};
  transparentTheme = transparentConfiguration.config.programs.opencode.themes.${themeName};

  expectedDefs = {
    inherit (palette)
      bg0
      bg1
      bg2
      bg3
      bg4
      bg5
      bg_red
      bg_green
      bg_blue
      bg_yellow
      fg
      red
      orange
      yellow
      green
      aqua
      blue
      purple
      grey0
      grey1
      grey2
      ;
  };

  expectedTheme = {
    primary = "green";
    secondary = "blue";
    accent = "aqua";
    error = "red";
    warning = "yellow";
    success = "green";
    info = "blue";
    text = "fg";
    textMuted = "grey1";
    background = "bg0";
    backgroundPanel = "bg1";
    backgroundElement = "bg2";
    border = "bg3";
    borderActive = "green";
    borderSubtle = "bg2";
    diffAdded = "green";
    diffRemoved = "red";
    diffContext = "grey1";
    diffHunkHeader = "aqua";
    diffHighlightAdded = "green";
    diffHighlightRemoved = "red";
    diffAddedBg = "bg_green";
    diffRemovedBg = "bg_red";
    diffContextBg = "bg1";
    diffLineNumber = "grey0";
    diffAddedLineNumberBg = "bg_green";
    diffRemovedLineNumberBg = "bg_red";
    markdownText = "fg";
    markdownHeading = "green";
    markdownLink = "blue";
    markdownLinkText = "aqua";
    markdownCode = "green";
    markdownBlockQuote = "grey1";
    markdownEmph = "orange";
    markdownStrong = "yellow";
    markdownHorizontalRule = "bg4";
    markdownListItem = "aqua";
    markdownListEnumeration = "purple";
    markdownImage = "blue";
    markdownImageText = "aqua";
    markdownCodeBlock = "fg";
    syntaxComment = "grey1";
    syntaxKeyword = "red";
    syntaxFunction = "green";
    syntaxVariable = "fg";
    syntaxString = "green";
    syntaxNumber = "purple";
    syntaxType = "yellow";
    syntaxOperator = "orange";
    syntaxPunctuation = "grey2";
  };
in
assert defaultConfiguration.config.programs.opencode.tui.theme == themeName;
assert defaultTheme."$schema" == "https://opencode.ai/theme.json";
assert defaultTheme.defs == expectedDefs;
assert defaultTheme.theme == expectedTheme;
assert transparentTheme.defs == expectedDefs;
assert transparentTheme.theme == expectedTheme // { background = "none"; };
pkgs.runCommand "everforest-home-manager-opencode" { } ''
  touch "$out"
''
