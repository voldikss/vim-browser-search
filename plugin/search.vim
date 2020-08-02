" ============================================================================
" FileName: search.vim
" Description:
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

if exists('g:did_load_browser_search')
  finish
endif

let g:browser_search_default_engine = get(g:, 'browser_search_default_engine', 'google')
let g:browser_search_builtin_engines = {
  \ 'baidu':'https://www.baidu.com/s?ie=UTF-8&wd=%s',
  \ 'bing': 'https://www.bing.com/search?q=%s',
  \ 'duckduckgo': 'https://duckduckgo.com/?q=%s',
  \ 'github':'https://github.com/search?q=%s',
  \ 'google':'https://google.com/search?q=%s',
  \ 'stackoverflow':'https://stackoverflow.com/search?q=%s',
  \ 'translate': 'https://translate.google.com/?sl=auto&tl=it&text=%s',
  \ 'wikipedia': 'https://en.wikipedia.org/wiki/%s',
  \ 'youtube':'https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch',
  \ }
if exists('g:browser_search_engines')
  call extend(g:browser_search_builtin_engines, g:browser_search_engines)
endif

nmap <silent> <Plug>SearchNormal  :set operatorfunc=search#search_normal<cr>g@
vmap <silent> <Plug>SearchVisual  :<c-u>call search#search_visual('')<cr>

" @deprecated
command! -nargs=? -range -complete=customlist,search#cmdline#complete
  \ SearchCurrentText call search#search_current(<q-args>)
command! -nargs=? -range -complete=customlist,search#cmdline#complete
  \ SearchVisualText  call search#search_visual(<q-args>)

command! -nargs=* -range -complete=customlist,search#cmdline#complete
  \ BrowserSearch     call search#start(<range>, <line1>, <line2>, <q-args>)

let g:did_load_browser_search = 1
