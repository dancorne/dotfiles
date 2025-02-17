return {
  {
    "alok/notational-fzf-vim",
    dependencies = { "junegunn/fzf.vim" },
    cmd = { "NV" },
    keys = {
      { "<leader>n",          [[<cmd>:NV ^#<CR>]],                                  desc = "Search all notes headings" },
      { "<leader>w<leader>w", [[<cmd>vsplit ~/notes/diary/`date +\%Y-\%W`.md<cr>]], desc = "Open diary page" },
    },
    init = function()
      vim.g.nv_search_paths = { "~/notes" }
      vim.g.nv_default_extension = '.md'
      vim.g.nv_create_note_key = 'ctrl-x'
      -- TODO how to define this variable in Lua?
      --vim.g.nv_keymap = { [[ctrl-s]] = 'split',
      --                    [[ctrl-v]] = 'vertical split',
      --                    [[ctrl-t]] = 'tabedit',
      --                    }
      vim.g.nv_create_note_window = 'vertical split'
      vim.g.nv_show_preview = 1
      vim.g.nv_wrap_preview_text = 0
      vim.g.nv_preview_width = '40%'
      vim.g.nv_preview_direction = 'right'
      vim.g.nv_use_short_pathnames = 1
      vim.g.nv_expect_keys = {}
    end,
  },
}
