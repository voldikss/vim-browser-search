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

function! search#start(range, line1, line2, argstr) abort
  let [text, engine] = search#cmdline#parse(split(a:argstr))

  if index(keys(g:browser_search_builtin_engines), engine) < 0
    call search#util#show_msg('Unknown search engine' . engine, 'error')
    return
  endif

  if empty(text)
    if a:range == 0
      let text = getline('.')
    elseif a:range == 1
      let text = getline('.')
    else
      if a:line1 == a:line2
        " https://vi.stackexchange.com/a/11028/17515
        let [lnum1, col1] = getpos("'<")[1:2]
        let [lnum2, col2] = getpos("'>")[1:2]
        let textlist = getline(lnum1, lnum2)
        if empty(textlist)
          call search#util#show_msg('No text were selected', 'error')
          return
        endif
        let textlist[-1] = textlist[-1][: col2 - 1]
        let textlist[0] = textlist[0][col1 - 1:]
      else
        let textlist = getline(a:line1, a:line2)
      endif
      let text = join(textlist)
    endif
  endif
  call s:search(text, engine)
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
  call s:search(text, g:browser_search_default_engine)
endfunction

function! search#search_current(argstr) abort
  let [_, engine] = search#cmdline#parse(split(a:argstr))
  if empty(engine)
    let engine = g:browser_search_default_engine
  endif
  if index(keys(g:browser_search_builtin_engines), engine) < 0
    call search#util#show_msg('Unknown search engine: ' . engine, 'error')
    return
  endif
  let text = expand('<cword>')
  call s:search(text, engine)
endfunction

function! search#search_visual(argstr) abort
  let [_, engine] = search#cmdline#parse(split(a:argstr))
  if empty(engine)
    let engine = g:browser_search_default_engine
  endif
  if index(keys(g:browser_search_builtin_engines), engine) < 0
    call search#util#show_msg('Unknown search engine: ' . engine, 'error')
    return
  endif
  let reg_tmp = @"
  normal! gv""y
  let text=@"
  let @" = reg_tmp
  unlet reg_tmp
  call s:search(text, engine)
endfunction
