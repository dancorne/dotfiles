return {
  {
    'pwntester/octo.nvim',
    cmd = { "Octo" },
    requires = {
      'nvim-lua/plenary.nvim',
      'ibhagwan/fzf-lua',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require "octo".setup({
        picker = "fzf-lua"
      })
    end
  },
  {
    "airblade/vim-gitgutter",
    init = function()
      vim.api.nvim_create_autocmd('BufWritePost', { -- TODO Is this still needed?
        pattern = '*',
        command = "execute 'GitGutterAll'"
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
