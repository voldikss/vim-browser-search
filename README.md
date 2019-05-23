# vim-searchme

A naive Vim/Neovim plugin to open browser and search text directly.

## Installation

```vim
Plug 'voldikss/vim-searchme'
```

## Basic

Use `<Leader>s` in *operator-pending* mode to search a word (for example, `<Leader>saw` to search a word). 

Use `<Leader>s` in visual mode to search for what you have selected. (for example, if you selected strings inside a bracket using `vas`, just type `<Leader>s` to search it).

Also you may try `<Leader>S`, with which you can input what you want to search in the cmdline.

## KeyMap

Here are some default key mappings

You can also define your own mappings, by remapping `<Leader>d`, `<Leader>w` or `<Leader>r`

```vim
" Type <Leader>s to trig searching in normal mode
nmap <silent> <Leader>s <Plug>SearchNormal
" Type <Leader>s to search selected text in visual mode
vmap <silent> <Leader>s <Plug>SearchVisual
" Type <Leader>S to input the text you want to search in the cmdline
nmap <silent> <Leader>S <Plug>SearchComand
```

## Variables

#### **`g:vsm_default_mappings`** 

> Whether to use the default key mapping, default: 1

#### **`g:vsm_search_engine`**

> Specify your default search engine, default: 'google'

```vim
" Example
let g:vsm_search_engine = 'bing'
```

#### **`g:vsm_query_map_added`**

> Your additional query map

```vim
" Example
let g:vsm_query_map_added = {
    \ 'wikipedia': 'https://en.wikipedia.org/wiki/{query}'
    \ }
```

## Commands

- Built-in commands

| command                             | introduction                                   |
|-------------------------------------|------------------------------------------------|
| `SearchCurrentText [search engine]` | Search text under the cursor                   |
| `SearchVisualText [search engine]`  | Search selected text                           |
| `Search [search engine] {text}`     | Search text (using specified search engine)    |
| `SearchInGithub {text}`             | Search text in [GitHub](https://github.com)    |
| `SearchInZhihu {text}`              | Search text in [Zhihu](https://www.zhihu.com/) |
| `...`                               | ...                                            |

- Define your own commands

```vim
" Example
command!  -nargs=+  SearchInGoogle  :call searchme#SearchIn(<q-args>, 'google')
```

## Todo

-   [x] Support operator-pending mode
-   [x] Go to the URL instead of searching it
-   [x] Customized key mapping
