return {
  {
    "nvim-treesitter/nvim-treesitter",
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
    },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- disable rtp plugin, as we only need its queries for mini.ai
          -- In case other textobject modules are enabled, we will load them
          -- once nvim-treesitter is loaded
          require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
          load_textobjects = true
        end,
      },
    },
  },
  {
    "nvim-treesitter/playground",
    cmd = "TSPlaygroundToggle"
  }
}
