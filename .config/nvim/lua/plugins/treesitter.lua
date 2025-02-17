return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false, -- Used for statusline
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync" },
    main = "nvim-treesitter.configs",
    keys = {
      { "<c-space>", desc = "Increment selection" },
      { "<bs>",      desc = "Decrement selection", mode = "x" },
    },
    opts = {
      ensure_installed = {
        "bash",
        "go",
        "hcl",
        "python",
        "dockerfile",
        "ruby",
        "yaml",
        "json",
        "lua",
      },
      auto_install = false,
      sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
      --modules = {
      highlight = {
        enable = true, -- false will disable the whole extension
      },
      indent = {
        enable = true, -- false will disable the whole extension
      },
      incremental_selection = {
        enable = true, -- false will disable the whole extension
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
          goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer", ["]A"] = "@parameter.inner" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
          goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer", ["[A"] = "@parameter.inner" },
        },
      },
    },
    init = function()
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false
    end,
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle"
  }
}
