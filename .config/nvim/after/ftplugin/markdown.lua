--Navigate notes with `gf`
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = vim.fn.expand("~") .. '/notes/*',
  callback = function()
    vim.opt_local.path:append('~/notes/**')
  end,
})
vim.opt.suffixesadd:append([[.md]])
