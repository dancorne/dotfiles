return {
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-fzy-native.nvim",

  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
    cmd = { "FZF", "Commits", "History", "Buffers", "Tags", "Rg", "ProjectileProject" },
    keys = {
      { "<Leader><Leader>", ":Rg<CR>" },
      { "<Leader>f",        ":FZF<CR>" },
      { "<Leader>c",        ":Commits<CR>" },
      { "<Leader>:",        ":History:<CR>" },
      { "<Leader>b",        ":Buffers<CR>" },
      { "<Leader>t",        ":Tags<CR>" },
      { "<c-x><c-k>",       "<plug>(fzf-complete-word)",    mode = { 'i' } },
      { "<c-x><c-f>",       "<plug>(fzf-complete-path)",    mode = { 'i' } },
      { "<c-x><c-j>",       "<plug>(fzf-complete-file-ag)", mode = { 'i' } },
      { "<c-x><c-l>",       "<plug>(fzf-complete-line)",    mode = { 'i' } },
      { "<leader><tab>",    "<plug>(fzf-maps-n)",           mode = { 'n' } },
      { "<leader><tab>",    "<plug>(fzf-maps-x)",           mode = { 'x' } },
      { "<leader><tab>",    "<plug>(fzf-maps-o)",           mode = { 'o' } },
      { "<Leader>p",        ":call ProjectileProject()<CR>" },
    },
    config = function()
      vim.api.nvim_create_autocmd({ 'Filetype' }, {
        pattern = 'fzf',
        command = "tnoremap <buffer> <esc> <c-c>",
      })

      vim.cmd([[command! -bang -nargs=* Rg
        \ call fzf#vim#grep(
        \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
        \   <bang>0 ? fzf#vim#with_preview('up:60%')
        \           : fzf#vim#with_preview('right:50%:hidden', '?'),
        \   <bang>0)
      ]])
      -- TODO Get the Luafication working
      -- vim.api.nvim_create_user_command('Rg',
      --   function(args)
      --     api.nvim_call_function([[
      --       fzf#vim#grep(
      --       'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>),
      --       1,
      --       <bang>0 ? fzf#vim#with_preview('up:60%') : fzf#vim#with_preview('right:50%:hidden', '?'),
      --       <bang>0)
      --     ]])
      --   end,
      --   { nargs = '*', bang = true })
      vim.cmd([[
        function! s:projects_sink(lines)
          if len(a:lines) < 1
            return
          endif
          let dir = a:lines[0]
          call fzf#vim#files(dir, {})
          startinsert
        endfunction

        function! ProjectileProject()
          let projects = 'find ~/code ~/code/infrastructure-modules/* ~/code/*/modules ~/code/infrastructure-live -maxdepth 1 -mindepth 1 -type d -not -name .git -not -name .github'
          return fzf#run(fzf#wrap('projects', {'source': projects, 'sink*': function('s:projects_sink')}))
          "return fzf#run('files', {'source': projects, 'sink*': 'cd'})
        endfunction
      ]])
    end
  }
}
