return {
	"SculptedSystems/motifs.nvim",
	version = "v0.1.0-rc.1",
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		base_url = "https://motifs.stuq.win",
		trigger_enabled = true,
		trigger_char = "@",
	},
	config = function(_, opts)
		require("motifs").setup(opts)

		-- The trigger sends every `@` query to base_url. Keep it off in herden.dev content,
		-- where `@` starts a citekey. The flag is global and read on each keypress, so set it per buffer entered.
		local herden = require("custom.herden")
		local function apply(buf)
			require("motifs.config").values.trigger_enabled = opts.trigger_enabled
				and not herden.contains(vim.api.nvim_buf_get_name(buf))
		end
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufFilePost" }, {
			group = vim.api.nvim_create_augroup("MotifsHerden", { clear = true }),
			callback = function(ev)
				apply(ev.buf)
			end,
		})
		-- The plugin loads on FileType, after the first buffer's BufEnter.
		apply(vim.api.nvim_get_current_buf())
	end,
}
