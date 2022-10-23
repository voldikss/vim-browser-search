" ============================================================================
" FileName: search.vim
" Description:
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

if exists('g:did_load_browser_search')
  finish
endif
let g:did_load_browser_search = 1

let s:path = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
let s:json_path = s:path . '/assets/json/engines.json'

let g:browser_search_default_engine = get(g:, 'browser_search_default_engine', 'google')
let g:browser_search_builtin_engines = json_decode(join(readfile(s:json_path), ''))
if exists('g:browser_search_engines')
  call extend(g:browser_search_builtin_engines, g:browser_search_engines)
endif

nnoremap <silent> <Plug>SearchNormal  :let g:browser_search_curpos = getpos('.') \| set operatorfunc=search#search_normal<cr>g@
vnoremap <silent> <Plug>SearchVisual  :<c-u>call search#search_visual()<cr>

command! -nargs=* -range BrowserSearch call search#start(<q-args>, visualmode(), <range>)
