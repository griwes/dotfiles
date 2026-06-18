-- general options
vim.o.wrap = true
vim.o.showmode = true
vim.o.termguicolors = true

-- mouse
vim.o.mouse = 'a'
vim.o.mousemodel = 'extend'
vim.o.mousemoveevent = true
vim.o.mousescroll = 'ver:15,hor:6'

-- sidebar options
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'

-- search options
vim.o.showmatch = true
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- indentation
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.scrolloff = 4
vim.o.smartindent = true

-- better wrapping
vim.o.breakindent = true
vim.o.breakindentopt = 'shift:4'
vim.o.linebreak = true

-- history options
vim.o.undolevels = 16384
vim.o.undofile = true

-- make updates on cursor hold faster
vim.o.updatetime = 300

-- stable splits
vim.o.splitkeep = 'screen'

-- some transparency
vim.o.pumblend = 30
vim.o.winblend = vim.g.neovide and 66 or 0

-- global statusline
vim.o.laststatus = 3

-- compact line spacing for Neovide and GUI-ish UIs
vim.o.linespace = -3

-- leader
vim.g.mapleader = ','
vim.g.localleader = ','

-- allow more tabs, will be useful with tabulature
vim.g.tabpagemax = 1000

-- Neovide policy
-- Keep rendered UI backgrounds opaque while making only the normal editor
-- background translucent. Lowering `neovide_opacity` instead makes the entire
-- OS window translucent, including statuslines, popups, and other backgrounds.
vim.g.neovide_opacity = 1.0
vim.g.neovide_normal_opacity = 0.8515625
vim.g.neovide_experimental_layer_grouping = true
vim.g.neovide_refresh_rate = 120
vim.g.neovide_underline_stroke_scale = 0.5
vim.g.neovide_cursor_animation_length = 0.02
vim.g.neovide_scroll_animation_length = 0.15

vim.g.neovide_floating_blur_amount_x = 2.5
vim.g.neovide_floating_blur_amount_y = 2.5
vim.g.neovide_floating_shadow = false
vim.g.neovide_floating_corner_radius = 0.5
