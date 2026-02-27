{ config, lib, ... }:
{
  mkEverforestOption = {
    name,
    useGlobalEnable ? true,
    default ? if useGlobalEnable then config.everforest.enable else false,
  }:{
    enable = lib.mkEnableOption "Wheter to enable Everforest theme for ${name}" // { default = true; };
  };
}
