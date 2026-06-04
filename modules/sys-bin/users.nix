{ pkgs, ... }:
{
  users.users = {
    # main
    jar = {
      isNormalUser = true;
      shell = pkgs.zsh; # makes user explicitly use zsh
      # add groups:
      extraGroups = [
        "wheel"
        "video"
        "input"
        "networkmanager"
        "libvirtd"
      ];
    };
  }; # end of users declair
}
