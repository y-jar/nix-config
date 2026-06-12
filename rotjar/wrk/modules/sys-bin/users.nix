{ pkgs, ... }:
{
  users.users = {
    # main
    jar = {
      isNormalUser = true;
      shell = pkgs.zsh; # makes user explicitly use zsh
      extraGroups = [
        "wheel" # sudo
        "video" # video
        "input" # input
        "networkmanager" # wifi
        "libvirtd" # virt
        "kvm" # virt
      ];
    };
  }; # end of users declair
}
