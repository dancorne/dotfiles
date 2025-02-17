return {
  {
    "github/copilot.vim",
    init = function()
      vim.g.copilot_filetypes = { ["*"] = false }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" },                       -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken",                          -- Only on MacOS or Linux
    opts = {
      chat_autocomplete = false,
    },
  },
}
