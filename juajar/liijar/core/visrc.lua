-- vis: ~/.config/vis/visrc.lua
-- Colors follow the terminal's gruvbox ANSI palette (usrset.theming); the
-- shipped `default` theme maps onto the terminal colors so vis looks gruvbox.
-- vis has no built-in LSP; use nvf (neovim) for that. Syntax highlighting is
-- on by default (syntax auto).

require('vis')

-- window-scoped options (apply to each newly opened window)
vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	win.options.numbers = true        -- absolute line numbers
	win.options.relativenumbers = true
	win.options.cursorline = true     -- highlight current line
	win.options.showtabs = true       -- render tab markers
	win.options.expandtab = true      -- tabs -> spaces
	win.options.tabwidth = 4          -- your files are 2-space/4-space anyway
end)

-- global options
vis.events.subscribe(vis.events.INIT, function()
	vis:command('set autoindent')
	vis:command('set syntax auto')    -- per-filetype syntax highlighting
end)

-- ---- autopair [] {} () <> --------------------------------------------------
local PAIRS = {
	{ o = '[', c = ']' },
	{ o = '{', c = '}' },
	{ o = '(', c = ')' },
	{ o = '<', c = '>' },
}

for _, p in ipairs(PAIRS) do
	-- opening char: insert the pair (vis:insert bypasses mappings so no
	-- recursion), then park the cursor between the two.
	vis:map(vis.modes.INSERT, p.o, function()
		vis:insert(p.o .. p.c)
		vis.win.selection.pos = vis.win.selection.pos - 1
	end, 'autopair (open) ' .. p.o)

	-- closing char: if the char under the cursor is the matching close, skip
	-- past it; otherwise insert the closing char literally.
	vis:map(vis.modes.INSERT, p.c, function()
		local line = vis.win.file.lines[vis.win.selection.line]
		local ahead = line and line:sub(vis.win.selection.col, vis.win.selection.col) or ''
		if ahead == p.c then
			vis.win.selection.pos = vis.win.selection.pos + 1
		else
			vis:insert(p.c)
		end
	end, 'autopair (close) ' .. p.c)
end