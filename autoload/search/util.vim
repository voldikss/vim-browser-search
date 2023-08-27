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

" https://vi.stackexchange.com/questions/42717/how-do-i-turn-a-string-into-url-encoded-string
" URL encode a string. ie. Percent-encode characters as necessary.
function! search#util#url_encode(string)

    let result = ""

    let characters = split(a:string, '.\zs')
    for character in characters
        if character == " "
            let result = result . "+"
        elseif CharacterRequiresUrlEncoding(character)
            let i = 0
            while i < strlen(character)
                let byte = strpart(character, i, 1)
                let decimal = char2nr(byte)
                let result = result . "%" . printf("%02x", decimal)
                let i += 1
            endwhile
        else
            let result = result . character
        endif
    endfor

    return result

endfunction

" Returns 1 if the given character should be percent-encoded in a URL encoded
" string.
function! CharacterRequiresUrlEncoding(character)

    let ascii_code = char2nr(a:character)
    if ascii_code >= 48 && ascii_code <= 57
        return 0
    elseif ascii_code >= 65 && ascii_code <= 90
        return 0
    elseif ascii_code >= 97 && ascii_code <= 122
        return 0
    elseif a:character == "-" || a:character == "_" || a:character == "." || a:character == "~"
        return 0
    endif

    return 1

endfunction
