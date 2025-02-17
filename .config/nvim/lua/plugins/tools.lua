return {
  {
    --:SQLUFormatter to format SQL
    "vim-scripts/SQLUtilities",
    ft = { 'sql' },
    dependencies = {
      "vim-scripts/Align",
    }
  },
  --:DirDiff for directory diffing
  "will133/vim-dirdiff",
  {
    "tpope/vim-vinegar",
    keys = {
      { "-", command = [[:Lexplore<CR>]], description = "Browse file system" }
    },
    init = function()
      vim.g.netrw_preview = 1
      vim.g.netrw_winsize = 15
    end
  },
  --Shortcuts like ]q
  "tpope/vim-unimpaired",
  "junegunn/vim-peekaboo",
  --Browse history with :UndotreeToggle
  --ysaW etc. for surrounding
  "tpope/vim-surround",
  "christoomey/vim-tmux-navigator",
  {
    "ojroques/vim-oscyank",
    config = function()
      -- TODO check this actually works...
      vim.api.nvim_create_autocmd({ "TextYankPost" }, {
        pattern = "*",
        command = "if v:event.operator is 'y' && v:event.regname is '+' | execute 'OSCYankRegister +' | endif"
      })
    end
  }

}
