vim.opt.number = true
vim.opt.hidden = true
vim.opt.cursorline = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

vim.cmd.colorscheme("gruvbox8")
--set syntax
--vim.opt.t_Co=256 --256 colours
vim.opt.background = "dark"
vim.opt.termguicolors = true
vim.opt.listchars = {
  eol = "$",
  tab = ">-",
  trail = "~",
  extends = ">",
  precedes = "<",
  nbsp = "^",
}
--vim.opt.statusline=%<%f\ %h%m%r(%{FugitiveHead()})[%{nvim_treesitter#statusline()}]%=%y[%l,%c][%L][%{&ff}][%p%%]
vim.opt.statusline = "%<%f\\ %h%m%r(%{FugitiveHead()})[%{nvim_treesitter#statusline()}]%=%y[%l,%c][%L][%{&ff}][%p%%]"
vim.opt.signcolumn = "yes"

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  command = "if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankRegister +' | endif"
})

-- Open a file on the last line we were at
-- Doesn't work like this, probably due to the quoting nightmare
--vim.api.nvim_create_autocmd({ "BufReadPost" }, {
--  pattern = "*",
--  command = 'if line("\'\"") > 0 && line("\'\"") <= line("$") | exe "normal! g\'\"" | endif'
--})
-- Is this needed any more?
--autocmd BufEnter * :syntax sync fromstart
vim.filetype.add {
  extension = {
    tf = 'hcl'
  },
  filename = {
    ['terragrunt.hcl'] = 'hcl'
  }
}
