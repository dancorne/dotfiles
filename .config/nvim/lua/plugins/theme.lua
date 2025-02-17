return {
  {
    "lifepillar/vim-gruvbox8",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd.colorscheme("gruvbox8")
      vim.opt.background = "dark"
      vim.opt.termguicolors = true
    end,
  },
}
