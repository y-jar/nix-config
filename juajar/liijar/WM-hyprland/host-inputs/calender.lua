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

-- assign default workspaces to monitors
hl.workspace_rule({ monitor = "DP-3", workspace = "1" })
hl.workspace_rule({ monitor = "HDMI-A-1", workspace = "11" })
hl.workspace_rule({ monitor = "DP-2", workspace = "21" })
