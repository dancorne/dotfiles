return {
  {
    "github/copilot.vim",
    cmd = { 'Copilot' },
    init = function()
      vim.g.copilot_filetypes = { ["*"] = false }
    end,
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cmd = { 'CopilotChatClose', 'CopilotChatDebugInfo', 'CopilotChatFix', 'CopilotChatModels', 'CopilotChatReset', 'CopilotChatStop', 'CopilotChat', 'CopilotChatCommit', 'CopilotChatDocs', 'CopilotChatFixDiagnostic', 'CopilotChatOpen', 'CopilotChatReview', 'CopilotChatTests', 'CopilotChatAgents', 'CopilotChatCommitStaged', 'CopilotChatExplain', 'CopilotChatLoad', 'CopilotChatOptimize', 'CopilotChatSave', 'CopilotChatToggle' },
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
