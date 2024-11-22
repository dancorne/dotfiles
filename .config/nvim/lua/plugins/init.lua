return {
  { "folke/lazy.nvim", tag = "stable" },
  "nvim-lua/popup.nvim",
  "nvim-lua/plenary.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-fzy-native.nvim",
  "artempyanykh/zeta-note",
  "ThePrimeagen/git-worktree.nvim",
  "kyazdani42/nvim-web-devicons",
  "pwntester/octo.nvim",
  "ElPiloto/telescope-vimwiki.nvim",
  "christoomey/vim-tmux-navigator",
  --Git tools
  "airblade/vim-gitgutter",
  "tpope/vim-fugitive",
  "tpope/vim-rhubarb",
  "tpope/vim-dispatch",
  --Themes
  "morhetz/gruvbox",
  "lifepillar/vim-gruvbox8",
  "aonemd/kuroi.vim",
  --:SQLUFormatter to format SQL
  "vim-scripts/SQLUtilities",
  "vim-scripts/Align",
  --:DirDiff for directory diffing
  "will133/vim-dirdiff",
  --Browsing with -
  "tpope/vim-vinegar",
  --Shortcuts like ]q
  "tpope/vim-unimpaired",
  --FZF searching
  "junegunn/fzf", -- { 'dir': '~/.fzf', 'do': './install --all' }
  "junegunn/fzf.vim",
  "junegunn/vim-peekaboo",
  --Browse history with :UndotreeToggle
  --ysaW etc. for surrounding
  "tpope/vim-surround",
  --Task and wiki
  "alok/notational-fzf-vim",
  --vimwiki/vimwiki",
  --Live previews of patterns and substitutions
  "ojroques/vim-oscyank",
  "majutsushi/tagbar",
  "github/copilot.vim",

  --  {
  --    "yetone/avante.nvim",
  --    event = "VeryLazy",
  --    lazy = false,
  --    opts = {
  --      provider = "copilot"
  --    },
  --    -- if you want to download pre-built binary, then pass source=false. Make sure to follow instruction above.
  --    -- Also note that downloading prebuilt binary is a lot faster comparing to compiling from source.
  --    build = ":AvanteBuild source=false",
  --    dependencies = {
  --      "stevearc/dressing.nvim",
  --      "nvim-lua/plenary.nvim",
  --      "MunifTanjim/nui.nvim",
  --      --- The below dependencies are optional,
  --      "zbirenbaum/copilot.lua", -- for providers='copilot'
  --    },
  --  }
}
