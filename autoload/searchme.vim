" @Author: voldikss
" @Date: 2018-08-22 17:51:06
" @Last Modified by: voldikss
" @Last Modified time: 2019-01-26 14:52:35

let s:search_engine = get(g:, 'g:search_engine', 'google')

let s:query_map = {
        \ 'google':'https://google.com/search?q={query}',
        \ 'mathematica':'https://www.wolframalpha.com/input/?i={query}',
        \ 'duckduckgo': 'https://duckduckgo.com/?q={query}',
        \ 'bing': 'https://www.bing.com/search?q={query}',
        \ 'baidu':'https://www.baidu.com/s?ie=UTF-8&wd={query}',
        \ 'github':'https://github.com/search?q={query}',
        \ 'stackoverflow':'https://stackoverflow.com/search?q={query}',
        \ 'askubuntu': 'https://askubuntu.com/search?q={query}',
        \ 'wikipedia': 'https://en.wikipedia.org/wiki/{query}',
        \ 'reddit':'https://www.reddit.com/search?q={query}',
        \ 'twitter-search': 'https://twitter.com/search/{query}',
        \ 'twitter-user': 'https://twitter.com/{query}',
        \ 'zhihu':'https://www.zhihu.com/search?q={query}',
        \ 'bilibili':'http://search.bilibili.com/all?keyword={query}',
        \ 'youtube':'https://www.youtube.com/results?search_query={query}&page=&utm_source=opensearch'
        \ }

" Add user-added query maps
if exists('g:query_map_added')
    call extend(s:query_map, g:query_map_added)
endif


function! s:Search(text, search_engine)
    if has_key(s:query_map, a:search_engine)
        let l:query_url = s:query_map[a:search_engine]
    else
        echoerr "Unknown search engine."
        return
    endif

    " Escape for use string as shell command argument
    let l:text = shellescape(a:text)

    " Whether selected text contains URL
    let l:url_in_text = matchstr(l:text, 'https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*')

    if l:url_in_text !=# ''
        let l:url = l:url_in_text
    else
        let l:url = substitute(l:query_url, '{query}', l:text, 'g')
    endif

    " Get rid of wouble-quote, single-quote, back-quote, back-slash, whitespace
    let l:url = substitute(l:url, "[\"'`]"," ",'g')
    let l:url = substitute(l:url, '\s\+',"%20",'g')
    let l:url = trim(l:url,"%20")
    let l:url = trim(l:url,"\\")

    " Windows(including mingw)
    if has('win32') || has('win64') || has('win32unix')
        let l:cmd = 'rundll32 url.dll,FileProtocolHandler ' . '"' . l:url . '"'
    elseif has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin'
        let l:cmd = 'open ' . '"' . l:url . '"'
    elseif executable('xdg-open')
        let l:cmd = 'xdg-open ' . '"' . l:url . '"'
    else
        echoerr "Browser not found."
    endif

    " Async search
    if exists('*jobstart')
        call jobstart(l:cmd)
    elseif exists('*job_start')
        call job_start(l:cmd)
    else
        call system(l:cmd)
    endif
endfunction

function! searchme#Start(type)
    let l:save_tmp = @"

    if index(['v', 'V'], a:type) >=0
        normal! `<v`>y
    elseif index(['char', 'line'], a:type) >= 0
        normal! `[v`]y
    else
        return
    endif

    let l:select_text = @"
    let @" = l:save_tmp

    call s:Search(l:select_text, s:search_engine)
endfunction

function! searchme#SearchIn(...)
    " Users can decide which search engine to use
    if a:0 == 1
        let l:text = a:1
        let l:pos = match(l:text,' ')
        "Search engine not specified, use the default
        if l:pos < 0
            echom "[vim-search-me] Use default search engine."
            let l:search_engine = s:search_engine
            let l:keyword = trim(l:text)
        else
            let l:search_engine = l:text[: l:pos-1]
            let l:keyword = l:text[l:pos+1 :]
        endif
    else
        let l:keyword = a:1
        let l:search_engine = a:2
    endif
    call s:Search(l:keyword, l:search_engine)
endfunction

function! searchme#SearchCurrentText(...)
    if a:0 == 0
        let l:search_engine = tolower(s:search_engine)
    else
        let l:search_engine = tolower(trim(a:1))
    endif
    let l:keyword = expand("<cword>")
    call s:Search(l:keyword, l:search_engine)
endfunction

function! searchme#SearchVisualText(...)
    if a:0 == 0
        let l:search_engine = tolower(s:search_engine)
    else
        let l:search_engine = tolower(trim(a:1))
    endif
    try
        let l:save_tmp = @"
        normal! gv"ay
        let l:select_text=@"
    finally
        let @" = l:save_tmp
    endtry
    call s:Search(l:select_text, l:search_engine)
endfunction

function! searchme#Complete(arg_lead, cmd_line, cursor_pos)
    let l:cmd_line_before_cursor = a:cmd_line[:a:cursor_pos - 1]
    let l:args = split(l:cmd_line_before_cursor, '\v\\@<!(\\\\)*\zs\s+', 1)
    call remove(l:args, 0) " Remove the command's name
    if len(l:args) == 1 " At search engine's position
        let l:candidates = keys(s:query_map)
        let l:prefix = l:args[0]
        if !empty(l:prefix) " If l:prefix is empty we want to return all options
            let l:candidates = filter(keys(s:query_map), 'v:val[:len(l:prefix) - 1] == l:prefix')
        endif
        return sort(l:candidates)
    endif
endfunction
