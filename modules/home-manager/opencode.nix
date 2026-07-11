{
  applicationThemeNames,
  everforestLib,
  everforestPalette,
}:
{ config, lib, ... }:
let
  applicationThemeName =
    if builtins.length applicationThemeNames == 1 then
      builtins.head applicationThemeNames
    else
      throw "Home Manager single-theme module expected exactly one Application Theme name";
  cfg = config.everforest.${applicationThemeName};
in
{
  options.everforest.${applicationThemeName} =
    everforestLib.mkEverforestOption { name = applicationThemeName; }
    // {
      transparentBackground = lib.mkEnableOption "transparent background for opencode" // {
        default = false;
      };
    };

  config = lib.mkIf (cfg.enable && config.programs.opencode.enable) {
    programs.opencode = {
      tui.theme = lib.mkDefault "everforest-dark-hard";
      themes.everforest-dark-hard = {
        "$schema" = "https://opencode.ai/theme.json";
        defs = {
          inherit (everforestPalette)
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
        theme = {
          primary = "green";
          secondary = "blue";
          accent = "aqua";
          error = "red";
          warning = "yellow";
          success = "green";
          info = "blue";
          text = "fg";
          textMuted = "grey1";
          background = if cfg.transparentBackground then "none" else "bg0";
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
      };
    };
  };
}
