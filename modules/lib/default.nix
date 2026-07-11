{ config, lib, ... }:
{
  mkEverforestOption = { name }: {
    enable = lib.mkEnableOption "Whether to enable Everforest theme for ${name}" // {
      default = config.everforest.enable;
    };
  };
}
