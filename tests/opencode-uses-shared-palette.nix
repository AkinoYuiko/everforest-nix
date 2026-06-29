let
  source = builtins.readFile ../modules/home-manager/opencode.nix;
  split = needle: builtins.split needle source;
  contains = needle: builtins.length (split needle) > 1;
in
assert contains "everforestPalette";
assert contains "inherit ";
assert contains "everforestPalette";
assert !(contains "#272e33");
assert !(contains "#493B40");
true
