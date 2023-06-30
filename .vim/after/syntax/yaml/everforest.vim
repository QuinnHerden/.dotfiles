if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'yaml') ==# -1
    call add(g:everforest_loaded_file_types, 'yaml')
else
    finish
endif
" syn_begin: yaml {{{
highlight! link yamlKey Orange
highlight! link yamlConstant Purple
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
