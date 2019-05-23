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
        let query_url = s:query_map[a:search_engine]
    else
        echoerr "Unknown search engine."
        return
    endif

    " Escape for use string as shell command argument
    let text = shellescape(a:text)

    " Whether selected text contains URL
    let url_in_text = matchstr(text, 'https\?:\/\/\(\w\+\(:\w\+\)\?@\)\?\([A-Za-z][-_0-9A-Za-z]*\.\)\{1,}\(\w\{2,}\.\?\)\{1,}\(:[0-9]\{1,5}\)\?\S*')

    if url_in_text !=# ''
        let url = url_in_text
    else
        let url = substitute(query_url, '{query}', text, 'g')
    endif

    " Get rid of wouble-quote, single-quote, back-quote, back-slash, whitespace
    let url = substitute(url, "[\"'`]"," ",'g')
    let url = substitute(url, '\s\+',"%20",'g')
    let url = substitute(url, '\$','\\$','g')
    let url = trim(url,"%20")
    let url = trim(url,"\\")

    " Windows(including mingw)
    if has('win32') || has('win64') || has('win32unix')
        let cmd = 'rundll32 url.dll,FileProtocolHandler ' . '"' . url . '"'
    elseif has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin'
        let cmd = 'open ' . '"' . url . '"'
    elseif executable('xdg-open')
        let cmd = 'xdg-open ' . '"' . url . '"'
    else
        echoerr "Browser not found."
    endif

    " Async search
    if exists('*jobstart')
        call jobstart(cmd)
    elseif exists('*job_start')
        call job_start(cmd)
    else
        call system(cmd)
    endif
endfunction

function! searchme#Start(type)
    let save_tmp = @"

    if index(['v', 'V'], a:type) >=0
        normal! `<v`>y
    elseif index(['char', 'line'], a:type) >= 0
        normal! `[v`]y
    else
        return
    endif

    let select_text = @"
    let @" = save_tmp

    call s:Search(select_text, s:search_engine)
endfunction

function! searchme#SearchIn(...)
    " Users can decide which search engine to use
    if a:0 == 1
        let text = a:1
        let pos = match(text,' ')
        "Search engine not specified, use the default
        if pos < 0
            echom "[vim-search-me] Use default search engine."
            let search_engine = s:search_engine
            let keyword = trim(text)
        else
            let search_engine = text[: pos-1]
            let keyword = text[pos+1 :]
        endif
    else
        let keyword = a:1
        let search_engine = a:2
    endif
    call s:Search(keyword, search_engine)
endfunction

function! searchme#SearchCurrentText(...)
    if a:0 == 0
        let search_engine = tolower(s:search_engine)
    else
        let search_engine = tolower(trim(a:1))
    endif
    let keyword = expand("<cword>")
    call s:Search(keyword, search_engine)
endfunction

function! searchme#SearchVisualText(...)
    if a:0 == 0
        let search_engine = tolower(s:search_engine)
    else
        let search_engine = tolower(trim(a:1))
    endif
    try
        let save_tmp = @"
        normal! gv"ay
        let select_text=@"
    finally
        let @" = save_tmp
    endtry
    call s:Search(select_text, search_engine)
endfunction

function! searchme#Complete(arg_lead, cmd_line, cursor_pos)
    let cmd_line_before_cursor = a:cmd_line[:a:cursor_pos - 1]
    let args = split(cmd_line_before_cursor, '\v\\@<!(\\\\)*\zs\s+', 1)
    call remove(args, 0) " Remove the command's name
    if len(args) == 1 " At search engine's position
        let candidates = keys(s:query_map)
        let prefix = args[0]
        if !empty(prefix) " If prefix is empty we want to return all options
            let candidates = filter(keys(s:query_map), 'v:val[:len(prefix) - 1] == prefix')
        endif
        return sort(candidates)
    endif
endfunction
