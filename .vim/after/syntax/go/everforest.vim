if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'go') ==# -1
    call add(g:everforest_loaded_file_types, 'go')
else
    finish
endif
" syn_begin: go {{{
" builtin: https://github.com/google/vim-ft-go {{{
highlight! link goDirective PurpleItalic
highlight! link goConstants Aqua
highlight! link goDeclType OrangeItalic
" }}}
" polyglot: {{{
highlight! link goPackage PurpleItalic
highlight! link goImport PurpleItalic
highlight! link goVarArgs Blue
highlight! link goBuiltins Green
highlight! link goPredefinedIdentifiers Aqua
highlight! link goVar Orange
" }}}
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
