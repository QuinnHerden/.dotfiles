if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'json') ==# -1
    call add(g:everforest_loaded_file_types, 'json')
else
    finish
endif
" syn_begin: json {{{
highlight! link jsonKeyword Orange
highlight! link jsonQuote Grey
highlight! link jsonBraces Fg
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
