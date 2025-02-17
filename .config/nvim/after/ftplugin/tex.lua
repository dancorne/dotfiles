vim.opt.iskeyword:append(":")
vim.opt_local.makeprg = [[pdflatex\ --shell-escape\ '%']]
-- TODO Are these still used
vim.g.tex_flavor = 'latex'
vim.g.Tex_DefaultTargetFormat = 'pdf'
vim.g.Tex_CompileRule_pdf = 'latexmk -pdf -pvc $*'
