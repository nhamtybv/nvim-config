-- keys.lua

local map = vim.api.nvim_set_keymap

-- open nvim-tree
map('n', 'nt', [[:NvimTreeToggle<CR>]], {})


-- find files
-- map('n', 'f', [[:Files<CR>]], {})
map('n', 'ff', [[:Telescope find_files<CR>]], {})
map('n', 'fg', [[:Telescope live_grep<CR>]], {})
map('n', 'fb', [[:Telescope buffers<CR>]], {})
map('n', 'fh', [[:Telescope help_tags<CR>]], {})

