return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NV" },
    keys = {
      { "<Leader><Leader>", function() require('fzf-lua').grep_project({ exec_empty_query = true }) end },
      { "<Leader>f",        function() require('fzf-lua').files() end },
      { "<Leader>c",        function() require('fzf-lua').git_commits() end },
      { "<Leader>:",        function() require('fzf-lua').command_history() end },
      { "<Leader>b",        function() require('fzf-lua').buffers() end },
      { "<Leader>r",        function() require('fzf-lua').lsp_live_workspace_symbols() end },
      { "<Leader>g",        function() require('fzf-lua').git_branches() end },
      { "<Leader>p",        ":Projects<CR>" },
      { "<Leader>n",        ":NV ^#<CR>",                                                               desc = "Search note headings" },
    },
    opts = {
      notes_directory = '~/notes',
      projects_command =
      'find ~/code ~/code/infrastructure-modules/* ~/code/*/modules ~/code/infrastructure-live ~/.config -maxdepth 1 -mindepth 1 -type d -not -name .git -not -name .github',
    },
    config = function(_, opts)
      local fzflua = require 'fzf-lua'

      fzflua.register_ui_select()

      local function projects_picker()
        fzflua.fzf_exec(opts.projects_command,
          {
            actions = {
              ['default'] = function(selected, _) -- Switch to project and open file picker
                require('fzf-lua').files({ cwd = selected[1] })
              end
            }
          }
        )
      end
      vim.api.nvim_create_user_command('Projects', projects_picker, {})

      local function notes_picker(input)
        local query = input.args or ""
        fzflua.grep({
          search_paths = { opts.notes_directory },
          search = query,
          no_esc = true, -- Want to be able to search regex via rg directly
          path_shorten = true,
        })
      end
      vim.api.nvim_create_user_command('NV', notes_picker, { nargs = '*' })

      fzflua.setup({
        git = {
          branches = {
            cmd = "git branch --color --sort='-authordate:iso8601'",
          }
        }
      })
    end
  }
}
