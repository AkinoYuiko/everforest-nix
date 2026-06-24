{ everforestLib, ... }:
{ config, lib, ... }:
let
  cfg = config.everforest.opencode;
in
{
  options.everforest.opencode = everforestLib.mkEverforestOption { name = "opencode"; } // {
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
          bg0 = "#272e33";
          bg1 = "#2e383c";
          bg2 = "#374145";
          bg3 = "#414b50";
          bg4 = "#495156";
          bg5 = "#4f5b58";
          bg_red = "#4c3743";
          bg_green = "#3c4841";
          bg_blue = "#384b55";
          bg_yellow = "#45443c";
          fg = "#d3c6aa";
          red = "#e67e80";
          orange = "#e69875";
          yellow = "#dbbc7f";
          green = "#a7c080";
          aqua = "#83c092";
          blue = "#7fbbb3";
          purple = "#d699b6";
          grey0 = "#7a8478";
          grey1 = "#859289";
          grey2 = "#9da9a0";
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
