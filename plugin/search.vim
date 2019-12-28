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

nmap <silent> <Plug>SearchNormal  :set operatorfunc=search#SearchNormal<cr>g@
vmap <silent> <Plug>SearchVisual  :<c-u>call search#SearchVisual()<cr>

" Note:
" I added `-range` just for preventing from echoing errors when the commands were executed with range prefix
command! -complete=customlist,search#Complete -nargs=+ -range Search            call search#SearchCmdline(<q-args>)
command! -complete=customlist,search#Complete -nargs=? -range SearchCurrentText call search#SearchCurrent(<f-args>)
command! -complete=customlist,search#Complete -nargs=? -range SearchVisualText  call search#SearchVisual(<f-args>)

let g:did_load_browser_search = 1
