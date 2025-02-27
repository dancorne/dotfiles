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
  callback = function(event)
    local file = event.file
    if file == "" or string.find(file, '://') then
      return
    end

    local git_path = vim.fn.finddir(".git", file .. ";")
    local target_dir = vim.fn.fnamemodify(git_path == "" and file or git_path, ":h")
    local current_dir = vim.fn.getcwd()

    if current_dir ~= target_dir then
      vim.api.nvim_set_current_dir(target_dir)
      vim.env.GIT_DIR = git_path == "" and '~/.dotfiles' or nil
      vim.env.GIT_WORK_TREE = git_path == "" and '~/' or nil
      vim.g.gitgutter_git_args = git_path == "" and '--git-dir=$HOME/.dotfiles/ --work-tree=$HOME' or ""
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
