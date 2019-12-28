# vim-browser-search

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

Defaut:

```vim
  {
  \ 'google':'https://google.com/search?q=%s',
  \ 'github':'https://github.com/search?q=%s',
  \ 'stackoverflow':'https://stackoverflow.com/search?q=%s',
  \ 'bing': 'https://www.bing.com/search?q=%s',
  \ 'duckduckgo': 'https://duckduckgo.com/?q=%s',
  \ 'wikipedia': 'https://en.wikipedia.org/wiki/%s',
  \ 'youtube':'https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch',
  \ 'baidu':'https://www.baidu.com/s?ie=UTF-8&wd=%s'
  \ }
```

## Commands

#### `:Search {engine} {text}`

Search `text` with `engine`

#### `:SearchCurrentText [engine]`

Search the text under the cursor with `engine`, if no `engine`, use `g:browser_search_default_engine`

#### `:SearchVisualText [engine]`

Search the selected text with `engine`, if no `engine`, use `g:browser_search_default_engine`
