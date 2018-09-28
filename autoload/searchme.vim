" @Author: clouduan
" @Date: 2018-08-22 17:51:06
" @Last Modified by: clouduan
" @Last Modified time: 2018-08-24
function! s:search_it(keyword, ...)
    if !a:0 == 0
        let s:search_engine = tolower(a:1)
    else
        let s:search_engine = tolower(g:search_engine)
    endif
    if has_key(g:query_map, s:search_engine)
        let s:query_url = g:query_map[s:search_engine]
    else
        echoerr "Unknow search engine."
    endif
    let l:url = substitute(s:query_url, '{query}', a:keyword, 'g')
    let l:url = substitute(l:url, ' ', '%20', 'g')

    " windows(mingw)
    if has('win32') || has('win64') || has('win32unix')
        let cmd = 'start rundll32 url.dll,FileProtocolHandler ' . l:url
    elseif has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin'
        let cmd = 'open ' . l:url
    elseif executable('xdg-open')
        let cmd = 'xdg-open ' . l:url
    else
        echoerr "No browser path found, please contact the developer."
    endif

    if exists('*jobstart')
        call jobstart(cmd)
    elseif exists('*job_start')
        call job_start(cmd)
    else
        call system(cmd)
    endif
endfunction

function! searchme#search_in(...)
    " User can input which search_engine to use
    if a:0 == 1
        let s:text = a:1
        let s:pos = match(s:text,' ')
        " No search engine specified, will use the default
        if s:pos < 0
            echom "Use default engine."
            let s:search_engine = g:search_engine
            let s:keyword = s:text
        else
            let s:search_engine = s:text[: s:pos-1]
            let s:keyword = s:text[s:pos+1 :]
        endif
    else
        let s:keyword = a:1
        let s:search_engine = a:2
    endif
    call <SID>search_it(s:keyword, s:search_engine)
endfunction

function! searchme#search_current_text()
    let s:keyword = expand("<cword>")
    call <SID>search_it(s:keyword)
endfunction

function! searchme#search_visual_text()
    try
        let s:save_tmp = @a
        normal! gv"ay
        let s:select_text=@a
    finally
        let @a = s:save_tmp
    endtry
    call <SID>search_it(s:select_text)
endfunction

function! searchme#complete(arg_lead, cmd_line, cursor_pos)
    let l:cmd_line_before_cursor = a:cmd_line[:a:cursor_pos - 1]
    let l:args = split(l:cmd_line_before_cursor, '\v\\@<!(\\\\)*\zs\s+', 1)
    call remove(l:args, 0) " Remove the command's name
    if len(l:args) == 1 " At search engine's position
        let l:candidates = keys(g:query_map)
        let l:prefix = l:args[0]
        if !empty(l:prefix) " If l:prefix is empty we want to return all options
            let l:candidates = filter(keys(g:query_map), 'v:val[:len(l:prefix) - 1] == l:prefix')
        endif
        return sort(l:candidates)
    endif
endfunction
