" @Author: clouduan
" @Date: 2018-08-22 17:50:56
" @Last Modified by: clouduan
" @Last Modified time: 2018-08-22 21:10:28
if !exists('g:browser_path')
    let g:browser_path = "/usr/bin/google-chrome"
endif

if !exists('g:search_engine')
    if has('win32') || has('win64')
        let g:search_engine = 'C://Program Files (x86)/Google/Chrome/Application/chrome.exe'
    elseif has('unix')
        let g:search_engine = "google"
    endif
endif

if !exists('g:query_map')
    let g:query_map = {
                \ 'google':'https://google.com/search\?q\={query}',
                \ 'github':'https://github.com/search\?q\={query}',
                \ 'stackoverflow':'https://stackoverflow.com/search\?q\={query}',
                \ 'bilibili':'http://search.bilibili.com/all\?keyword\={query}',
                \ 'askubuntu': 'https://askubuntu.com/search\?q\={query}',
                \ 'wikipedia': 'https://en.wikipedia.org/wiki/{query}',
                \ 'duckduckgo': 'https://duckduckgo.com/\?q\={query}',
                \ 'twitter-search': 'https://twitter.com/search/{query}',
                \ 'twitter-user': 'https://twitter.com/{query}',
                \ 'reddit':'https://www.reddit.com/search\?q\={query}',
                \ 'youtube':'https://www.youtube.com/results\?search_query\={query}\&page\=\&utm_source\=opensearch',
                \ 'zhihu':'https://www.zhihu.com/search\?q\={query}',
                \ 'baidu':'https://www.baidu.com/s\?ie\=UTF-8\&wd\={query}'
                \}
endif

command! SearchCurrentText :call searchme#search_current_text()
command! SearchVisualText  :call searchme#search_visual_text()

command! -complete=customlist,searchme#complete -nargs=+ Search                :call searchme#search_in(<q-args>)
command!                                        -nargs=+ SearchInGoogle        :call searchme#search_in(<q-args>, 'google')
command!                                        -nargs=+ SearchInGithub        :call searchme#search_in(<q-args>, 'github')
command!                                        -nargs=+ SearchInStackoverflow :call searchme#search_in(<q-args>, 'stackoverflow')
command!                                        -nargs=+ SearchInBilibili      :call searchme#search_in(<q-args>, 'bilibili')
command!                                        -nargs=+ SearchInZhihu         :call searchme#search_in(<q-args>, 'zhihu')
command!                                        -nargs=+ SearchInBaidu         :call searchme#search_in(<q-args>, 'baidu')
