" ============================================================================
" FileName: search.vim
" Description:
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

scriptencoding utf-8

let s:engines = {
  \ 'google':'https://google.com/search?q=%s',
  \ 'github':'https://github.com/search?q=%s',
  \ 'stackoverflow':'https://stackoverflow.com/search?q=%s',
  \ 'bing': 'https://www.bing.com/search?q=%s',
  \ 'duckduckgo': 'https://duckduckgo.com/?q=%s',
  \ 'wikipedia': 'https://en.wikipedia.org/wiki/%s',
  \ 'youtube':'https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch',
  \ 'baidu':'https://www.baidu.com/s?ie=UTF-8&wd=%s'
  \ }

if exists('g:browser_search_engines')
  call extend(s:engines, g:browser_search_engines)
endif

function! s:Search(text, engine) abort
  let url = s:engines[a:engine]
  " Replace `\n`, preserve `\`
  let text = substitute(a:text, '\n', ' ', 'g')
  let text = substitute(text, '\\', '\\\', 'g')

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
  let url = s:SafeTrim(url,'%20')
  let url = s:SafeTrim(url,"\\")
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
  else
    call s:ShowMsg('Browser was not found', 'error')
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

function! search#SearchCmdline(args) abort
  let args = split(a:args, '\v\s+')
  let engine = args[0]
  if index(keys(s:engines), engine) < 0
    call s:ShowMsg('Unknown search engine: ' . engine, 'error')
    return
  endif
  let text = join(args[1:], ' ')
  call s:Search(text, engine)
endfunction

function! search#SearchNormal(visual_type) abort
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
  call s:Search(text, g:browser_search_default_engine)
endfunction

function! search#SearchCurrent(...) abort
  let engine = (a:0 == 0 ? g:browser_search_default_engine : a:1)
  if index(keys(s:engines), engine) < 0
    call s:ShowMsg('Unknown search engine: ' . engine, 'error')
    return
  endif
  let text = expand('<cword>')
  call s:Search(text, engine)
endfunction

function! search#SearchVisual(...) abort
  let engine = (a:0 == 0 ? g:browser_search_default_engine : a:1)
  if index(keys(s:engines), engine) < 0
    call s:ShowMsg('Unknown search engine: ' . engine, 'error')
    return
  endif
  let reg_tmp = @a
  normal! gv"ay
  let text=@a
  let @a = reg_tmp
  unlet reg_tmp
  call s:Search(text, engine)
endfunction

function! search#Complete(arg_lead, cmd_line, cursor_pos) abort
  let cmd_line_before_cursor = a:cmd_line[:a:cursor_pos - 1]
  let args = split(cmd_line_before_cursor, '\v\\@<!(\\\\)*\zs\s+', 1)
  call remove(args, 0) " Remove the command's name
  if len(args) == 1 " At search engine's position
    let candidates = keys(s:engines)
    let prefix = args[0]
    if !empty(prefix) " If prefix is empty we want to return all options
      let candidates = filter(keys(s:engines), 'v:val[:len(prefix) - 1] ==# prefix')
    endif
    return sort(candidates)
  endif
endfunction

function! s:Echo(group, msg) abort
  if a:msg ==# '' | return | endif
  execute 'echohl' a:group
  echo a:msg
  echon ' '
  echohl NONE
endfunction

function! s:Echon(group, msg) abort
  if a:msg ==# '' | return | endif
  execute 'echohl' a:group
  echon a:msg
  echon ' '
  echohl NONE
endfunction

function! s:ShowMsg(message, ...) abort
  if a:0 == 0
    let msg_type = 'info'
  else
    let msg_type = a:1
  endif

  if type(a:message) != 1
    let message = string(a:message)
  else
    let message = a:message
  endif

  call s:Echo('Constant', '[vim-browser-search]')

  if msg_type ==# 'info'
    call s:Echon('Normal', message)
  elseif msg_type ==# 'warning'
    call s:Echon('WarningMsg', message)
  elseif msg_type ==# 'error'
    call s:Echon('Error', message)
  endif
endfunction

function! s:SafeTrim(input, mask) abort
  if exists('*trim')
    return trim(a:input, a:mask)
  endif
  return a:input
endfunction
