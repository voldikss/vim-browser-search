# vim-searchme

A Neovim plugin to search the web for text selected in vim. This is especially
useful when you want to search the text under the cursor. 

This plugin supports many search engines such as Google, GitHub and so on.
You can also add your own search engine, see [`g:query`](#Variables)

### Install

Preferred plugin manager is [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'clouduan/vim-searchme'
```

### Config example

```vim
noremap  <Leader>ss :<C-u>SearchCurrentText<CR>
vnoremap <Leader>sv :<C-u>SearchVisualText<CR>
noremap  <Leader>sm :Search<Space>

let g:browser_path = 'your browser executable file path'
let g:search_engine = 'your default search engine'
```

### Commands

-   `SearchCurrentText` Search text under the cursor

-   `SearchVisualText` Search selected text

-   `Search [search engine] {text}` Search text (using specified search engine)

-   `SearchInGithub {text}` Search in GitHub

-   `SearchInGoogle {text}`

-   `SearchInStackoverflow {text}`

-   `SearchInBilibili {text}`

-   `SearchInZhihu {text}`

-   `SearchInBaidu {text}`

You can define more commands by yourself.

### Variables

-   `g:browser_path` Path of the browser executable file

    Default value on Windows:

    ```vim
    let g:browser_path = 'C://Program Files (x86)/Google/Chrome/Application/chrome.exe'
    ```

    on Linux or Mac OS:

    ```vim
    let g:browser = '/usr/bin/google-chrome'
    ```

-   `g:query_map` Search engine names and query urls
    ```vim
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
    ```

### Todo

-   [ ] Support operator-pending mode
