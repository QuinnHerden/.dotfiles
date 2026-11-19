return {
  'MeanderingProgrammer/render-markdown.nvim',
  version = '8.*',
  ft = 'markdown',
  dependencies = { 'nvim-treesitter/nvim-treesitter' },
  ---@module 'render-markdown'
  opts = function()
    -- Callouts (`> [!note]`, GitHub + Obsidian types) render by default.
    if vim.g.have_nerd_font then
      return {}
    end

    -- Without a Nerd Font, replace every default private-use glyph with plain text / basic Unicode.
    ---@type render.md.UserConfig
    local opts = {
      sign = { enabled = false },
      heading = { icons = {} },
      code = { language_icon = false },
      checkbox = {
        unchecked = { icon = '☐ ' },
        checked = { icon = '☑ ' },
        custom = { todo = { rendered = '◐ ' } },
      },
      link = {
        footnote = { icon = '' },
        image = '',
        email = '',
        hyperlink = '',
        wiki = { icon = '' },
        custom = {},
      },
      callout = {},
    }

    -- Callout labels and per-site link icons are keyed tables; read their names from the plugin's
    -- (internal) defaults. If that module moves, those keep their glyphs and the rest still applies.
    local ok, callout, link_custom = pcall(function()
      local defaults = require 'render-markdown.settings'
      local c, l = {}, {}
      for name, value in pairs(defaults.callout.default) do
        c[name] = { rendered = (value.rendered:gsub('^%S+ ', '')) }
      end
      for name in pairs(defaults.link.default.custom) do
        l[name] = { icon = '' }
      end
      return c, l
    end)
    if ok then
      opts.callout = callout
      opts.link.custom = link_custom
    end
    return opts
  end,
}
