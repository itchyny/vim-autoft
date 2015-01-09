" =============================================================================
" Filename: plugin/autoft.vim
" Author: itchyny
" License: MIT License
" Last Change: 2015/01/08 08:43:31.
" =============================================================================

if exists('g:loaded_autoft') || v:version < 700
  finish
endif
let g:loaded_autoft = 1

let s:save_cpo = &cpo
set cpo&vim

augroup autoft
  autocmd!
  autocmd CursorHold,CursorHoldI * if &l:ft ==# '' | sil! cal autoft#set() | en
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
