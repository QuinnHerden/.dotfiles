local herden = require("custom.herden")

-- Slug ids the site accepts: ^[a-z0-9]+(-[a-z0-9]+)*$
local function herden_id(title)
	local ascii = vim.fn.iconv(title or "", "utf-8", "ascii//TRANSLIT")
	-- macOS iconv leaves accent marks behind (é -> 'e); drop them before collapsing.
	local id = ascii:lower():gsub("['`^\"~]", ""):gsub("[^a-z0-9]+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
	if id == "" then
		error(("cannot make a herden.dev id from title %q"):format(title or ""))
	end
	return id
end

-- Workspace paths are realpath-resolved and a buffer maps to the workspace with the deepest
-- matching root, so order only matters for the startup fallback: when cwd is in no workspace,
-- the first one becomes active. Keep herden.dev last so its overrides aren't the default.
local workspaces = {}
for _, ws in ipairs({
	{ name = "testing", path = "~/repos/obsidian-motifs/vaults/Testing" },
	{ name = "Vault", path = "~/Documents/Vault" },
}) do
	if vim.fn.isdirectory(vim.fn.expand(ws.path)) == 1 then
		table.insert(workspaces, ws)
	end
end

local herden_path = herden.path()
if herden_path then
	-- The site build validates frontmatter strictly, so obsidian.nvim must never rewrite it.
	table.insert(workspaces, {
		name = "herden.dev",
		path = herden_path,
		strict = true,
		overrides = {
			frontmatter = { enabled = false },
			attachments = { folder = "./attachments" },
			notes_subdir = "posts",
			new_notes_location = "notes_subdir",
			note_id_func = herden_id,
			note = { template = "post.md" },
			templates = {
				folder = "_templates",
				substitutions = {
					-- Body of a YAML double-quoted scalar (JSON escapes are valid there). The template quotes it
					-- as `title: "{{title_yaml}}"` so Prettier leaves the placeholder alone.
					title_yaml = function(ctx)
						local title = ctx.partial_note and ctx.partial_note:display_name() or ""
						return (vim.json.encode(title):sub(2, -2))
					end,
				},
			},
		},
	})
end

return {
	"obsidian-nvim/obsidian.nvim",
	version = "*",
	lazy = true,
	ft = "markdown",
	cond = #workspaces > 0,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		workspaces = workspaces,
		-- render-markdown.nvim handles display.
		ui = { enable = false },
	},
}
