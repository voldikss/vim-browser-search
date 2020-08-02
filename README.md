# vim-browser-search

![CI](https://github.com/voldikss/vim-browser-search/workflows/CI/badge.svg)

This plugin helps perform a quick web search for the text selected in (Neo)Vim

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

#### `:BrowserSearch [--engine] [text]`

Search `text` with `engine`

e.g.
```vim
:BrowserSearch
:BrowserSearch --github
:BrowserSearch --github hello
:1,2BrowserSearch
:1,2BrowserSearch --github
:%BrowserSearch
:%BrowserSearch --github
```
