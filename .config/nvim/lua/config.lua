vim.g.mapleader = " "
vim.opt.inccommand = "nosplit"
vim.opt.number = true
vim.opt.hidden = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wildmenu = true
vim.opt.wildmode = { 'longest', 'list', 'full' }
vim.opt.splitright = true
vim.opt.mouse = 'r'
vim.opt.expandtab = true
vim.opt.shiftwidth = 2

vim.opt.listchars = {
  eol = "$",
  tab = ">-",
  trail = "~",
  extends = ">",
  precedes = "<",
  nbsp = "^",
}

if vim.fn.has('macunix') then -- TODO is this still necessary?
  vim.g.netrw_browsex_viewer = "open"
end
if vim.fn.executable('rg') then
  vim.opt.grepprg = "rg --vimgrep"
  vim.opt.grepformat = "%f:%l:%c:%m"
end


-- Open a file on the last line we were at (mark '")
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  callback = function()
    if vim.fn.line([['"]]) > 0 and vim.fn.line([['"]]) <= vim.fn.line([[$]]) then
      vim.cmd.normal([[g'"]])
    end
  end
})
--
-- Switch to project roots based on git directory location
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = '*',
  callback = function()
    local git_path = vim.fn.finddir(".git", ".;")
    if git_path ~= "" then
      local project_root = vim.fn.fnamemodify(git_path, ":h")
      vim.api.nvim_set_current_dir(project_root)
    end
  end
})

-- Persistent undo etc
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~') .. '/.local/share/nvim/undo'
vim.opt.directory = vim.fn.expand('~') .. '/.local/share/nvim/swp'
vim.opt.backupdir = vim.fn.expand('~') .. '/.local/share/nvim/backup'


-- Is this needed any more?
--autocmd BufEnter * :syntax sync fromstart

-- Recognise some non-standard file endings
vim.filetype.add {
  extension = {
    tf = 'hcl',
    tfvars = 'hcl',
    ['tf.erb'] = 'hcl',
    ['hcl.erb'] = 'hcl',
    ['json.tftpl'] = 'json',
  },
  filename = {
    ['terragrunt.hcl'] = 'hcl'
  }
}
