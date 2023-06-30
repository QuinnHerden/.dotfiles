if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'toml') ==# -1
    call add(g:everforest_loaded_file_types, 'toml')
else
    finish
endif
let s:configuration = everforest#get_configuration()
let s:palette = everforest#get_palette(s:configuration.background, s:configuration.colors_override)
" syn_begin: toml {{{
call everforest#highlight('tomlTable', s:palette.purple, s:palette.none, 'bold')
highlight! link tomlKey Orange
highlight! link tomlBoolean Aqua
highlight! link tomlTableArray tomlTable
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
