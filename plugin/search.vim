" ============================================================================
" FileName: search.vim
" Description:
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

if exists('g:did_load_browser_search')
  finish
endif
let g:did_load_browser_search = 1

let g:browser_search_default_engine = get(g:, 'browser_search_default_engine', 'google')
let g:browser_search_builtin_engines = {
  \ 'arxiv':         'https://arxiv.org/search/?query=%s&searchtype=all',
  \ 'baidu':         'https://www.baidu.com/s?ie=UTF-8&wd=%s',
  \ 'bing':          'https://www.bing.com/search?q=%s',
  \ 'bilibili':      'https://search.bilibili.com/all?keyword=%s',
  \ 'ctan':          'https://ctan.org/search?phrase=%s',
  \ 'cpan':          'https://metacpan.org/search?q=%s',
  \ 'csdn':          'https://so.csdn.net/so/search?q=%s',
  \ 'dlbp':          'https://dblp.org/search?q=%s',
  \ 'duckduckgo':    'https://duckduckgo.com/?q=%s',
  \ 'github':        'https://github.com/search?q=%s',
  \ 'google':        'https://google.com/search?q=%s',
  \ 'mdn':           'https://developer.mozilla.org/en-US/search?q=%s',
  \ 'npm':           'https://www.npmjs.com/search?q=%s',
  \ 'pypi':          'https://pypi.org/search/?q=%s',
  \ 'scholar':       'https://scholar.google.com/scholar?q=%s',
  \ 'stackoverflow': 'https://stackoverflow.com/search?q=%s',
  \ 'translate':     'https://translate.google.com/?sl=auto&tl=it&text=%s',
  \ 'wikipedia':     'https://en.wikipedia.org/wiki/%s',
  \ 'youtube':       'https://www.youtube.com/results?search_query=%s&page=&utm_source=opensearch',
  \ }
if exists('g:browser_search_engines')
  call extend(g:browser_search_builtin_engines, g:browser_search_engines)
endif

nnoremap <silent> <Plug>SearchNormal  :let g:browser_search_curpos = getpos('.') \| set operatorfunc=search#search_normal<cr>g@
vnoremap <silent> <Plug>SearchVisual  :<c-u>call search#search_visual()<cr>

command! -nargs=* -range BrowserSearch call search#start(<q-args>, visualmode(), <range>)
