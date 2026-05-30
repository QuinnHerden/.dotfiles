return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = {
			{
				name = "testing",
				path = "~/repos/obsidian-motifs/vaults/Testing",
			},
			{
				name = "Vault",
				path = "~/Documents/Vault"
			},
		},
	},
}
