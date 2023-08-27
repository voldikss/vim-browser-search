" ============================================================================
" FileName: search.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

scriptencoding utf-8

function! s:search(text, engine) abort
  let url = g:browser_search_builtin_engines[a:engine]
  " Replace `\n`, preserve `\`
  let text = substitute(a:text, '\n', ' ', 'g')
  let text = substitute(text, '\\', '\\\', 'g')
  let text = search#util#url_encode(text)

  " If selected text contains URL
  let url_in_text = matchstr(text, '\c\<\(\%([a-z][0-9A-Za-z_-]\+:\%(\/\{1,3}\|[a-z0-9%]\)\|www\d\{0,3}[.]\|[a-z0-9.\-]\+[.][a-z]\{2,4}\/\)\%([^ \t()<>]\+\|(\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\)\+\%((\([^ \t()<>]\+\|\(([^ \t()<>]\+)\)\)*)\|[^ \t`!()[\]{};:'."'".'".,<>?«»“”‘’]\)\)')
  if url_in_text !=# ''
    let url = url_in_text
  else
    let url = printf(url, text)
  endif

  " Escape double-quote, back-quote, back-slash, whitespace
  let url = substitute(url, '\(["`]\)','\="\\".submatch(1)','g')
  let url = substitute(url, '\$','\\$','g')
  let url = search#util#trim(url,'%20')
  let url = search#util#trim(url,"\\")
  if has('nvim')
    let url = shellescape(url)
  else
    let url = substitute(url, '\s', '\\ ', 'g')
  endif

  if has('win32') || has('win64') || has('win32unix')
    let cmd = 'rundll32 url.dll,FileProtocolHandler ' . url
  elseif has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin'
    let cmd = 'open ' . url
  elseif executable('xdg-open')
    let cmd = 'xdg-open ' . url
  elseif executable('wslview')
    let cmd = 'wslview ' . url
  else
    call search#util#show_msg('Browser was not found', 'error')
    return
  endif

  if exists('*jobstart')
    call jobstart(cmd)
  elseif exists('*job_start')
    call job_start(cmd)
  else
    call system(cmd)
  endif
endfunction

function! search#search_normal(visual_type) abort
  let reg_tmp = @"
  if index(['v', 'V'], a:visual_type) >=0
    normal! `<v`>y
  elseif index(['char', 'line'], a:visual_type) >= 0
    normal! `[v`]y
  else
    return
  endif
  let text = @"
  let @" = reg_tmp
  call s:search(text, get(b:, 'browser_search_default_engine', g:browser_search_default_engine))
  call setpos('.', g:browser_search_curpos)
endfunction

function! search#search_visual() abort
  let reg_tmp = @"
  normal! gv""y
  let text=@"
  let @" = reg_tmp
  call s:search(text, get(b:, 'browser_search_default_engine', g:browser_search_default_engine))
endfunction

let s:has_popup = has('textprop') && has('patch-8.2.0286')
let s:has_float = has('nvim') && exists('*nvim_win_set_config')
let s:text = ''
let s:enginelist = []
function! search#start(text, visualmode, range) abort
  if empty(a:text)
    if a:visualmode == 'v' && a:range == 2
      let s:text = search#util#get_selected_text()
    else
      let s:text = expand('<cword>')
    endif
  else
    let s:text = a:text
  endif
  if empty(search#util#trim(s:text, ' ')) | return | endif

  let s:enginelist = keys(g:browser_search_builtin_engines)
  let engine_index = index(s:enginelist, g:browser_search_default_engine)

  if s:has_popup
    function! s:bs_menu_filter(id, key)
      return popup_filter_menu(a:id, a:key)
    endfunction

    function! s:bs_menu_handler(id, index) abort
      if a:index == -1 | return | endif
      let engine = s:enginelist[a:index-1]
      call s:search(s:text, engine)
    endfunction

    call popup_menu(s:enginelist, {
      \ 'filter': function('s:bs_menu_filter'),
      \ 'callback': function('s:bs_menu_handler'),
      \ 'minheight': len(s:enginelist),
      \ 'minwidth': max(map(deepcopy(s:enginelist), {_, val -> len(val)})),
      \ 'title': 'Browser Search Engines',
      \ 'drap': v:true,
      \ 'resize': v:true,
      \ 'scrollbar': 1,
      \ })
    return
  endif

  if s:has_float
    let s:saved_cursor = &guicursor
    let bufnr = nvim_create_buf(v:false, v:true)
    let candidates = map(deepcopy(s:enginelist), { engine_index, val -> engine_index+1.'. '.val })
    call nvim_buf_set_lines(bufnr, 0, -1, v:true, candidates)
    call nvim_buf_set_option(bufnr, 'modifiable', v:false)

    let options = {
      \ 'width': max(map(deepcopy(s:enginelist), {_, val -> len(val)})) + 2,
      \ 'height': len(s:enginelist),
      \ 'relative': 'cursor',
      \ 'row': 0,
      \ 'col': 0,
      \ 'style': 'minimal',
      \}
    let s:winid = nvim_open_win(bufnr, v:true, options)
    call nvim_win_set_option(s:winid, 'foldcolumn', '1')
    call nvim_win_set_option(s:winid, 'cursorline', v:true)
    call nvim_win_set_option(s:winid, 'winhl', 'Normal:Pmenu,FoldColumn:Pmenu,CursorLine:PmenuSel')
    call nvim_win_set_cursor(s:winid, [engine_index+1, 0])

    if has('nvim-0.5.0') && !empty(s:saved_cursor)
      set guicursor+=a:ver1-Cursor/lCursor
    endif

    function! s:select_and_search() abort
      let engine = s:enginelist[line('.') - 1]
      call s:search(s:text, engine)
      call s:close_menu()
    endfunction

    function! s:close_menu() abort
      call nvim_win_close(s:winid, v:true)
      if has('nvim-0.5.0') && !empty(s:saved_cursor)
        let &guicursor = s:saved_cursor
      endif
    endfunction

    mapclear <buffer>
    nnoremap <nowait><buffer><silent> <CR>  :<C-u>call <SID>select_and_search()<CR>
    nnoremap <nowait><buffer><silent> l     :<C-u>call <SID>select_and_search()<CR>
    nnoremap <nowait><buffer><silent> <Esc> :<C-u>call <SID>close_menu()<CR>
    for idx in range(len(s:enginelist))
      execute printf('nmap <buffer><silent> %s :%s<CR><CR>', idx + 1, idx)
    endfor
    return
  endif

  let candidates = map(deepcopy(s:enginelist), { engine_index, val -> engine_index+1.'. '.val })
  let select = inputlist(candidates) - 1
  if select < 1 || select > len(candidates)
    return
  endif
  let engine = s:enginelist[select]
  call s:search(s:text, engine)
endfunction
