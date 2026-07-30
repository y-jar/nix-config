-- my keybindings
-- vars
local vars = require("hl.vars")
local utils = require("hl.utils")
local mainMod = vars.mainMod
local terminal = vars.terminal
local fileManager = vars.fileManager
local launcher = vars.launcher
local launcherPain = vars.launcherPain
local textEditor = vars.textEditor
local browser = vars.browser
local volumeMixer = vars.volumeMixer
local lockScreen = vars.lockScreen
local appStore = vars.appStore
local browserSearch = vars.browserSearch
local hyprpicker = vars.hyprpicker

-- Apps / Launchers
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(launcher))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(textEditor))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(appStore))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browserSearch))
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(volumeMixer))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("g4music"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(hyprpicker))
hl.bind(mainMod .. " + Alt + Space", hl.dsp.exec_cmd("jemoji"))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("foot --window-size-pixels=1600x800 --title=jwall-picker -e jwall"))

-- noctalia-shell
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(launcherPain))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("noctalia-shell ipc call panel-toggle control-center"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd("noctalia-shell ipc call settings-toggle"))

-- CORE-BINDINGS
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch hl.dsp.exit()"))
hl.bind("SUPER + SHIFT + ALT + Q", hl.dsp.exec_cmd("hyprctl kill"), { description = "Window: Forcefully zap a window" })
hl.bind("SUPER + ALT + L", hl.dsp.exec_cmd(lockScreen), { description = "Lock screen" })

-- Screenshot
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd("hyprshot region"), { description = "Screenshot: region" })
hl.bind("SUPER + CTRL + SHIFT + S", hl.dsp.exec_cmd("hyprshot monitor"), { description = "Screenshot: screen" })
hl.bind("SUPER + ALT + S", hl.dsp.exec_cmd("hyprshot window"), { description = "Screenshot: window" })

-- Window manipulation
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + Backslash", function() utils.float_center() end)
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", function()
    hl.dispatch(hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
end)
hl.bind(mainMod .. " + SHIFT + F", function()
    hl.dispatch(hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle" }))
end)

-- Scratchpad
hl.bind(mainMod .. " + grave", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + M", hl.dsp.window.move({ workspace = "special:magic" }))

-- MISCELLANEOUS
hl.bind(mainMod .. " + Tab", hl.dsp.layout("promote"))

-- ===============================[FOCUS + MOVE NAVIGATION]
-- hjkl: j/k = workspace up/down, h/l = monitor left/right
for dir, key in pairs({
    h = "h",
    j = "j",
    k = "k",
    l = "l",
}) do
    hl.bind("SUPER + " .. key, utils.focus(dir))
    hl.bind("SUPER + CTRL + " .. key, utils.move(dir))
end

-- Arrow keys: window focus + move (keeps existing behavior)
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + " .. arrowkey[i], hl.dsp.focus({ direction = focusdir[i] }),
        { description = "Window: Focus " .. arrowkey[i] })
end
for i = 1, 4 do
    local arrowkey = { "Left", "Right", "Up", "Down" }
    local focusdir = { "l", "r", "u", "d" }
    hl.bind("SUPER + SHIFT + " .. arrowkey[i], hl.dsp.window.move({ direction = focusdir[i] }),
        { description = "Window: Move " .. arrowkey[i] })
end

-- Consume/Expel columns
hl.bind("SUPER + bracketright", hl.dsp.layout("consume_or_expel next"))
hl.bind("SUPER + bracketleft", hl.dsp.layout("consume_or_expel prev"))
-- ===============================[FOCUS + MOVE NAVIGATION]

-- ===============================[WORKSPACE MANAGEMENT]
-- Cycle workspaces: SUPER + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
-- ===============================[WORKSPACE MANAGEMENT]

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
