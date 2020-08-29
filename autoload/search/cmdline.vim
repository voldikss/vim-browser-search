" ============================================================================
" FileName: cmdline.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

function! search#cmdline#parse(argstr) abort
  let engine = ''
  let text = ''
  let match_groups = matchlist(a:argstr, '\v(--([a-zA-z0-9]+))?\s*(.*)$')
  if !empty(match_groups)
    let engine = match_groups[2]
    let text = match_groups[3]
  endif
  if empty(engine)
    let engine = g:browser_search_default_engine
  endif
  return [text, engine]
endfunction

function! search#cmdline#complete(arg_lead, cmd_line, cursor_pos) abort
  let cmd_line_before_cursor = a:cmd_line[:a:cursor_pos - 1]
  let args = split(cmd_line_before_cursor, '\v\\@<!(\\\\)*\zs\s+', 1)
  call remove(args, 0) " Remove the command's name
  if len(args) == 1 " At search engine's position
    let candidates = map(keys(g:browser_search_builtin_engines), '"--" . v:val')
    let prefix = args[0]
    if !empty(prefix) " If prefix is empty we want to return all options
      let candidates = filter(candidates, 'v:val[:len(prefix) - 1] ==# prefix')
    endif
    return sort(candidates)
  endif
endfunction
