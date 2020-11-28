# vim-browser-search

This plugin helps perform a quick web search for the text selected in (Neo)Vim

![](https://user-images.githubusercontent.com/20282795/100518567-4f189580-31cd-11eb-91f1-4d9e70f5aa0a.png)

## Installation

```vim
Plug 'voldikss/vim-browser-search'
```

## Keymappings

This plugin doesn't supply any default mappings. Here are some recommended key mappings

```vim
nmap <silent> <Leader>s <Plug>SearchNormal
vmap <silent> <Leader>s <Plug>SearchVisual
```

## Use cases

- Select text and type `<Leader>s` to do a web search

- Type `<Leader>saw` in to search web for a word

- Type `<Leader>sa(` to search web for the text wrapped in the bracket

- Type `<Leader>sas` to search web for a sentence

- ...

## Variables

#### **`g:browser_search_default_engine`**

Defaut: `'google'`

#### **`g:browser_search_engines`**

Default:

```vim
  {
  \ 'baidu':'https://www.baidu.com/s?ie=UTF-8&wd=%s',
  \ 'bing': 'https://www.bing.com/search?q=%s',
  \ 'duckduckgo': 'https://duckduckgo.com/?q=%s',
  \ 'github':'https://github.com/search?q=%s',
  \ 'google':'https://google.com/search?q=%s',
  \ 'stackoverflow':'https://stackoverflow.com/search?q=%s',
  \ 'translate': 'https://translate.google.com/?sl=auto&tl=it&text=%s',
  \ 'wikipedia': 'https://en.wikipedia.org/wiki/%s',
  \ 'youtube':'https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch',
  \ }
```

## Commands

#### `:BrowserSearch [text]`

Search `text` with `engine`, if `text` is not given, use the word under
cursor.

Also, you can use this command in visual mode, i.e., `:'<,'>BrowserSearch`
