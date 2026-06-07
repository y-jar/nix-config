--


-- monitors
hl.monitor({
    output   = "DP-3",
    mode     = "preferred",
    position = "0x0",
    scale    = "auto",
})
-- secondary monitor
hl.monitor({
    output   = "HDMI-A-1",
    mode     = "preferred",
    position = "2560x10",
    scale    = "auto",
})
-- the third monitor
hl.monitor({
    output   = "DP-2",
    mode     = "preferred",
    position = "0x1440",
    scale    = "auto",
})
