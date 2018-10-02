# vim-searchme

A Vim/Neovim plugin to search the web for text selected in vim. This is especially
useful when you want to search the text under the cursor.

This plugin supports many search engines such as Google, GitHub and so on.
You can also add your own search engine, see [`g:query`](#variables)

### Install

You must have Neovim/Vim-8.0+ with job control API.

Preferred plugin manager is [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'VoldikSS/vim-searchme'
```

### Config example

```vim
" Keymaps
noremap  <Leader>ss :<C-u>SearchCurrentText<CR>
vnoremap <Leader>sv :<C-u>SearchVisualText<CR>
noremap  <Leader>sm :Search<Space>

" Variables (if not specified, use default instead)
let g:search_engine = 'your default search engine'
let g:query_map = 'your customized query map'
```

### Commands

-   `SearchCurrentText [search engine]` Search text under the cursor

-   `SearchVisualText [search engine]`  Search selected text

-   `Search [search engine] {text}`     Search text (using specified search engine)

-   `SearchInGithub {text}`

-   `SearchInGoogle {text}`

-   `SearchInSO {text}`

-   `SearchInBilibili {text}`

-   `SearchInZhihu {text}`

-   `SearchInBaidu {text}`

You can define more commands by yourself.

```vim
" Template
command!  -nargs=+  'command name'  :call searchme#SearchIn(<q-args>, 'search engine name')

" Examples
command!  -nargs=+  SearchInGoogle  :call searchme#SearchIn(<q-args>, 'google')
command!  -nargs=+  SearchInGithub  :call searchme#SearchIn(<q-args>, 'github')
```

### Variables

-   `g:search_engine`  Your default search engine

    Default: "google"

-   `g:query_map` Search engine names and query urls

    Default:
    ```vim
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
    ```

### Todo

-   [ ] Support operator-pending mode
