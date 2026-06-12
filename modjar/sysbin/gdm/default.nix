{
  ...
}:
{

  # this enables GDM, it is my fave, has to be picked via sysSettings.gdm.enable = true in sysSettings
  services.displayManager.gdm = {
    enable = true;
    # wayland = true;
  };
}
