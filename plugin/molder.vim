if exists('g:loaded_molder')
  finish
endif
let g:loaded_molder = 1

function! s:shutup_netrw() abort
  if exists('#FileExplorer')
    autocmd! FileExplorer *
  endif
  if exists('#NERDTreeHijackNetrw')
    autocmd! NERDTreeHijackNetrw *
  endif
endfunction

augroup _molder_
  autocmd!
  autocmd VimEnter * call s:shutup_netrw()
  autocmd BufEnter * call molder#init()
  autocmd DirChanged * call molder#chdir()
  autocmd BufReadCmd *://* call molder#handle_protocol('read')
  autocmd BufWriteCmd *://* call molder#handle_protocol('write')
augroup END

runtime! autoload/molder/extension/*.vim

nnoremap <silent> <plug>(molder-open) :<c-u>call molder#open()<cr>
nnoremap <silent> <plug>(molder-up) :<c-u>call molder#up()<cr>
nnoremap <silent> <plug>(molder-reload) :<c-u>call molder#reload()<cr>
nnoremap <silent> <plug>(molder-home) :<c-u>call molder#home()<cr>
nnoremap <silent> <plug>(molder-toggle-hidden) :<c-u>call molder#toggle_hidden()<cr>
