{ config, pkgs, lib, ... }:
{
  # =======================================USERS===============================================
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jar = {
   isNormalUser = true;
   shell = pkgs.zsh; # makes user explicitly use zsh
   # add groups:
   extraGroups = [ "wheel" "video" "input" "networkmanager" "libvirtd" ];
  }; # End of users
}