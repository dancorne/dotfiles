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


-- Open a file on the last line we were at (mark ")
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = "*",
  callback = function(event)
    local buf = event.buf
    local last_line = vim.api.nvim_buf_get_mark(buf, '"')[1]
    if last_line > 0 and last_line <= vim.api.nvim_buf_line_count(buf) then
      vim.api.nvim_win_set_cursor(0, { last_line, 0 })
    end
  end
})

-- Switch to project roots based on git directory location
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = '*',
  callback = function()
    local file_dir = vim.fn.expand('%:p:h')
    if vim.fn.isdirectory(file_dir) == 0 then
      return
    end
    local git_path = vim.fn.finddir(".git", file_dir .. ";")
    local target_dir = git_path ~= "" and vim.fn.fnamemodify(git_path, ":h") or file_dir
    local current_dir = vim.fn.getcwd()

    if current_dir ~= target_dir then
      vim.api.nvim_set_current_dir(target_dir)
    end
  end
})

-- Persistent undo
vim.opt.undofile = true

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
