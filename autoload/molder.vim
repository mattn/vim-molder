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

function! s:name(base, v) abort
  let l:type = a:v['type']
  if l:type ==# 'link' || l:type ==# 'junction'
    if isdirectory(resolve(a:base .. a:v['name']))
      let l:type = 'dir'
    endif
  endif
  return a:v['name'] .. (l:type ==# 'dir' ? '/' : '')
endfunction

function! molder#init() abort
  let l:path = resolve(expand('%:p'))
  if !isdirectory(l:path)
    return
  endif
  let l:dir = fnamemodify(l:path, ':p:gs!\!/!')
  if isdirectory(l:dir) && l:dir !~# '/$'
    let l:dir .= '/'
  endif

  if tr(bufname('%'), '\', '/') !=# l:dir
    exe 'noautocmd' 'silent' 'noswapfile' 'file' l:dir
  endif
  let b:dir = l:dir
  setlocal modifiable
  setlocal filetype=molder buftype=nofile bufhidden=wipe nobuflisted noswapfile
  setlocal nowrap cursorline
  let l:files = map(readdirex(l:path, '1', {'sort': 'none'}), {_, v -> s:name(l:dir, v)})
  if !get(g:, 'molder_show_hidden', 0)
    call filter(l:files, 'v:val =~# "^[^.]"')
  endif
  silent keepmarks keepjumps call setline(1, sort(l:files, function('s:sort')))
  setlocal nomodified nomodifiable
  for l:fn in filter(split(execute('function'), "\n"), 'v:val =~# "^function molder#extension#\\w\\+#init().*"')
    call call(split(l:fn, ' ')[1][:-3], [])
  endfor
endfunction

function! molder#open() abort
  exe 'edit' b:dir .. substitute(getline('.'), '/$', '', '')
endfunction

function! molder#up() abort
  let l:dir = substitute(b:dir, '/$', '', '')
  let l:name = fnamemodify(l:dir, ':t:gs!\!/!')
  let l:dir = fnamemodify(l:dir, ':p:h:h:gs!\!/!')
  exe 'edit' l:dir
  call search('\v^' .. l:name, 'c')
endfunction

function! molder#home() abort
  edit ~/
endfunction

function! molder#reload() abort
  edit
endfunction

function! molder#curdir() abort
  return get(b:, 'dir', '')
endfunction

function! molder#current() abort
  return getline('.')
endfunction

function! molder#error(msg) abort
  redraw
  echohl Error
  echomsg a:msg
  echohl None
endfunction
