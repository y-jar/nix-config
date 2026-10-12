-- my hyprland config!
-- This file is the head, it requires the files that actually runs the config

-- template
-- require("template")

-- Base things
require("hl.rules")
require("hl.colors")
require("hl.utils")
require("hl.keybinds")
require("hl.animations")
require("hl.genr")
require("hl.autostart") -- any thing that should run on startup

-- Host-specific inputs
require("host-inputs.input")
