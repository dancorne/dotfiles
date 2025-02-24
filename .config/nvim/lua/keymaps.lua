-- Global mappings.

-- Move search results to the centre of the screen
vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Make it easier to escape term mode
vim.keymap.set("t", "<Esc><Esc>", [[<C-\><C-n>]])
vim.keymap.set("t", "<C-j>", [[<C-\><C-n><C-w><C-j>]])
vim.keymap.set("t", "<C-k>", [[<C-\><C-n><C-w><C-k>]])
vim.keymap.set("t", "<C-h>", [[<C-\><C-n><C-w><C-h>]])
vim.keymap.set("t", "<C-l>", [[<C-\><C-n><C-w><C-l>]])
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "fzf",
  command = "tnoremap <buffer> <esc><esc> <c-c>"
})

--TERRAFORM TERRAGRUNT
--Only works when in the infrastructure-live root
-- TODO Test these commands
vim.api.nvim_create_user_command('Terragrunt',
  [[vsplit | term cd %:p:h && aws-vault exec '%:s?/.*??-ops' -- terragrunt plan -lock=false]],
  {}
)
vim.api.nvim_create_user_command('TerragruntApply',
  [[vsplit | term cd %:p:h && aws-vault exec '%:s?/.*??-full' -- terragrunt apply]],
  {}
)
vim.api.nvim_create_user_command('TFLocalModules',
  [[<line1>,<line2>s^\vsource.*/([a-zA-Z1-9_-]+)\.git//([a-zA-Z1-9/-]+)\?ref=.*^source = "/Users/dancorne/code/\1//\2"^e | norm!``]],
  { range = true }
)
vim.api.nvim_create_user_command('TFModuleVersion',
  [[<line1>,<line2>s^\v(source.*)\?ref=.*^\1?ref=<args>"^e | norm!``]],
  { range = true, nargs = 1 }
)
vim.api.nvim_create_user_command('AtlantisPlan',
  function()
    os.execute([[
    gh pr view --web && \
    git push && \
    sleep 3 && \
    gh run-plan
    ]])
  end,
  {}
)
