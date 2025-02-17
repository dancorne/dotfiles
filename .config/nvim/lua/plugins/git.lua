return {
  {
    'pwntester/octo.nvim',
    commands = { "Octo" },
    requires = {
      'nvim-lua/plenary.nvim',
      'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    "airblade/vim-gitgutter",
    init = function()
      vim.api.nvim_create_autocmd('BufWritePost', { -- TODO Is this still needed?
        pattern = '*',
        command = "execute 'GitGutterAll'"
      })
      vim.api.nvim_create_autocmd('BufEnter', {
        pattern = {
          vim.fn.expand('~') .. '/*',
          vim.fn.expand('~') .. '/config/**',
        },
        callback = function()
          vim.g.gitgutter_git_args = '--git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
        end
      })
    end
  },
  {
    "tpope/vim-fugitive",
    commands = { 'Git' },
    lazy = false, -- Used statusline
    keys = {
      { "<Leader>gs", ":Git<CR>" },
      { "<Leader>ga", ":Gwrite<CR>" },
      { "<Leader>gc", ":Git commit -v -q<CR>" },
      { "<Leader>gd", ":Gitdiffsplit<CR>" },
      { "<Leader>go", ":Git checkout <Space>" },
      { "<Leader>gb", ":Git branch <Space>" },
      { "<Leader>gg", ":Ggrep <Space>" },
    },
    init = function()
      vim.cmd([[cnoreabbrev Gblame Gblame -w]])
      vim.cmd([[hi def link gitcommitOverflow Error]])
    end
  },
  "tpope/vim-rhubarb",
}
