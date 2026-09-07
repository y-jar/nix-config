-- here is where anything that should be autostarted will be defined
hl.on("hyprland.start", function()
    -- core
    hl.exec_cmd("noctalia-shell")                                    -- shell
    hl.exec_cmd("gnome-keyring-daemon --start --components=secrets") -- keyring
    -- hl.exec_cmd("hypridle") -- idle manager
    -- audio
    hl.exec_cmd("easyeffects --hide-window --service-mode") -- audio effects
    hl.exec_cmd("pavucontrol")                              -- audio volume control
    -- wallpaper
    hl.exec_cmd("awww-daemon")
    hl.exec_cmd("random-wall &")
    -- misc
    hl.exec_cmd("hyprctl setcursor jcsr 36")           -- set cursor
end)
