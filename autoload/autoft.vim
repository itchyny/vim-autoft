" =============================================================================
" Filename: autoload/autoft.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/02/25 23:54:58.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! autoft#set() abort
  if &l:filetype !=# '' || !get(b:, 'autoft_enable', get(g:, 'autoft_enable', 1))
    return
  endif
  try
    let save_cpo = &cpo
    set cpo&vim
    let maxline = min([max([get(g:, 'autoft_maxline', 10), 1]), line('$')])
    let maxcol = max([get(g:, 'autoft_maxcol', 80), 10]) - 1
    let lines = map(range(1, maxline), 'getline(v:val)[:(maxcol)]')
    if len(lines) == 1 && lines[0] ==# ''
      return
    endif
    let ftpat = {}
    for ftpat in get(g:, 'autoft_config', [])
      for line in lines
        if line =~# ftpat.pattern && ftpat.filetype !=# ''
          let &l:filetype = ftpat.filetype
          return
        endif
      endfor
    endfor
  catch
    call autoft#error(v:exception, ftpat)
  finally
    let &cpo = save_cpo
  endtry
endfunction

function! autoft#error(message, ftpat) abort
  let prefix = '[autoft]: '
  let filetype = has_key(a:ftpat, 'filetype') ? 'filetype: ' . a:ftpat.filetype : ''
  let pattern = has_key(a:ftpat, 'pattern') ? 'pattern: ' . a:ftpat.pattern : ''
  let message = 'message: ' . substitute(a:message, '^Vim[^:]*:', '', '')
  let error = prefix . join(filter([ filetype, pattern, message ], 'v:val !=# ""'), ', ')
  let s:messages = get(s:, 'messages', {})
  if has_key(s:messages, error)
    return
  endif
  let s:messages[error] = 1
  echohl ErrorMsg
  echom error
  echohl None
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
