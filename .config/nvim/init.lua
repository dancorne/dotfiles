require("config")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins", {
  change_detection = {
    enabled = false,
  },
})

-- Status line depends on both Fugitive and Treesitter
vim.opt.statusline = [[(%{FugitiveHead()})%<%f %h%m%r%{nvim_treesitter#statusline()}%=%y[%l,%c][%L][%p%%] ]]
-- Signcolumn for both gitgutter and LSP diagnostics
vim.opt.signcolumn = "yes"
