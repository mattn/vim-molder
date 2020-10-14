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
augroup END

runtime! autoload/molder/extension/*.vim
