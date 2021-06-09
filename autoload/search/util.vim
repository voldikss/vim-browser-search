" ============================================================================
" FileName: util.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

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

function! search#util#show_msg(message, ...) abort
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

function! search#util#trim(input, mask) abort
  let input = substitute(a:input, a:mask . '$', '', '')
  let input = substitute(input, '^' . a:mask, '', '')
  return input
endfunction

function! search#util#get_selected_text() abort
  let col1 = getpos("'<")[2]
  let col2 = getpos("'>")[2]
  let text = getline('.')
  if empty(text)
    call skylight#util#show_msg('No content', 'error')
    return ''
  endif
  let text = text[col1-1 : col2-1]
  return text
endfunction
