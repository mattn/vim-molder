function! s:shutup_netrw() abort
  augroup FileExplorer
    autocmd!
  augroup END
endfunction

function! s:sort(lhs, rhs) abort
  if a:lhs[-1:] ==# '/' && a:rhs[-1:] !=# '/'
    return -1
  elseif a:lhs[-1:] !=# '/' && a:rhs[-1:] ==# '/'
    return 1
  endif
  if a:lhs < a:rhs
    return -1
  elseif a:lhs > a:rhs
    return 1
  endif
  return 0
endfunction

function! molder#init() abort
  call s:shutup_netrw()
  let l:path = expand('%:p')
  if !isdirectory(l:path)
    return
  endif
  let l:dir = fnamemodify(l:path, ':p:gs!\!/!')
  if isdirectory(l:dir) && l:dir !~# '/$'
    let l:dir .= '/'
  endif

  if tr(bufname('%'), '\', '/') !=# dir
    exe 'noautocmd' 'silent' 'noswapfile' 'file' l:dir
  endif
  let b:dir = l:dir
  setlocal filetype=molder buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal nowrap cursorline
  let l:files = map(readdirex(l:path, '1', {'sort': 'none'}), {_, v -> v['name'] .. (v['type'] ==# 'dir' ? '/' : '')})
  if !get(g:, 'molder_show_hidden', 0)
    call filter(l:files, 'v:val =~# "^[^.]"')
  endif
  silent keepmarks keepjumps call setline(1, sort(l:files, function('s:sort')))
endfunction

function! molder#open() abort
  exe 'edit' b:dir .. getline('.')
endfunction

function! molder#up() abort
  let l:dir = fnamemodify(b:dir, ':p:h:h:gs!\!/!')
  exe 'edit' l:dir
endfunction