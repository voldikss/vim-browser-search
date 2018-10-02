" @Author: VoldikSS
" @Date: 2018-08-22 17:50:56
" @Last Modified by: VoldikSS
" @Last Modified time: 2018-10-02

if !exists('g:search_engine')
    let g:search_engine = "google"
endif

if !exists('g:query_map')
    let g:query_map = {
                \ 'google':'https://google.com/search\?q\={query}',
                \ 'duckduckgo': 'https://duckduckgo.com/\?q\={query}',
                \ 'bing': 'https://www.bing.com/search?q\={query}',
                \ 'baidu':'https://www.baidu.com/s\?ie\=UTF-8\&wd\={query}',
                \ 'github':'https://github.com/search\?q\={query}',
                \ 'stackoverflow':'https://stackoverflow.com/search\?q\={query}',
                \ 'askubuntu': 'https://askubuntu.com/search\?q\={query}',
                \ 'wikipedia': 'https://en.wikipedia.org/wiki/{query}',
                \ 'reddit':'https://www.reddit.com/search\?q\={query}',
                \ 'twitter-search': 'https://twitter.com/search/{query}',
                \ 'twitter-user': 'https://twitter.com/{query}',
                \ 'zhihu':'https://www.zhihu.com/search\?q\={query}',
                \ 'bilibili':'http://search.bilibili.com/all\?keyword\={query}',
                \ 'youtube':'https://www.youtube.com/results\?search_query\={query}\&page\=\&utm_source\=opensearch'
                \}
endif

command! -complete=customlist,searchme#Complete -nargs=?        SearchCurrentText :call searchme#SearchCurrentText(<f-args>)
command! -complete=customlist,searchme#Complete -nargs=? -range SearchVisualText  :call searchme#SearchVisualText(<f-args>)

command! -complete=customlist,searchme#Complete -nargs=+        Search            :call searchme#SearchIn(<q-args>)
command!                                        -nargs=+        SearchInGoogle    :call searchme#SearchIn(<q-args>, 'google')
command!                                        -nargs=+        SearchInBaidu     :call searchme#SearchIn(<q-args>, 'baidu')
command!                                        -nargs=+        SearchInGithub    :call searchme#SearchIn(<q-args>, 'github')
command!                                        -nargs=+        SearchInSO        :call searchme#SearchIn(<q-args>, 'stackoverflow')
command!                                        -nargs=+        SearchInBilibili  :call searchme#SearchIn(<q-args>, 'bilibili')
command!                                        -nargs=+        SearchInZhihu     :call searchme#SearchIn(<q-args>, 'zhihu')
