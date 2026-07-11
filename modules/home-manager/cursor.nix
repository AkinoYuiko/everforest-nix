{ everforestLib, ... }:
{ pkgs, config, lib, ... }:
let
  cfg = config.everforest.cursor;
in
{
  options.everforest.cursor = everforestLib.mkEverforestOption { name = "cursor"; };
  config = {
    home.pointerCursor = lib.mkIf cfg.enable {
      enable = lib.mkDefault true;
      name = lib.mkDefault "everforest-cursors";
      size = 32;
      gtk = lib.mkIf config.gtk.enable {
        enable = lib.mkDefault true;
      };
      package = pkgs.stdenv.mkDerivation rec {
        name = "everforest-cursors";
        pname = name;
        src = fetchTarball {
          url = "https://github.com/talwat/everforest-cursors/releases/latest/download/everforest-cursors-variants.tar.bz2";
          sha256 = "0q4b1xnn65hj1jq812fsqmfgb6ilxp3kr4j17vkmv1pjgpxpa6ad";
        };
        nativeBuildInputs = [ pkgs.gnused ];
        installPhase = ''
          runHook preInstall
          ${pkgs.coreutils-full}/bin/mkdir -p $out/share/icons
          ${pkgs.coreutils-full}/bin/mv everforest-cursors $out/share/icons
          ${pkgs.gnused}/bin/sed -i 's/Everforest cursors/everforest-cursors/g' $out/share/icons/everforest-cursors/index.theme
          runHook postInstall
        '';
      };
    };
  };
}
