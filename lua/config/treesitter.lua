local M = {}

function M.setup()
	require("nvim-treesitter.configs").setup {
		ensure_installed = "all",

		-- Install languages synchronously (only applied to `ensure_installed`)
		sync_install = false,

		highlight = {
			-- `false` will disable the whole extension
			enable = true,
		},
	}
end

return M
