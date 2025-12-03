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

function! s:natural_sort(lhs, rhs) abort
  if a:lhs[-1:] ==# '/' && a:rhs[-1:] !=# '/'
    return -1
  elseif a:lhs[-1:] !=# '/' && a:rhs[-1:] ==# '/'
    return 1
  endif
  return s:natural(a:lhs, a:rhs)
endfunction

function! s:natural(lhs, rhs)
  let l:ilhs = 0
  let l:irhs = 0
  let l:llhs = len(a:lhs)
  let l:lrhs = len(a:rhs)

  while l:ilhs < l:llhs && l:irhs < l:lrhs
    if a:lhs[l:ilhs] =~ '\d' && a:rhs[l:irhs] =~ '\d'
      let l:nlhs = 0
      let l:nrhs = 0
      let l:zlhs = 0
      let l:zrhs = 0

      while l:ilhs < l:llhs && a:lhs[l:ilhs] =~ '\d'
        let l:nlhs = l:nlhs * 10 + str2nr(a:lhs[l:ilhs])
        let l:zlhs += 1
        let l:ilhs += 1
      endwhile
      while l:irhs < l:lrhs && a:rhs[l:irhs] =~ '\d'
        let l:nrhs = l:nrhs * 10 + str2nr(a:rhs[l:irhs])
        let l:zrhs += 1
        let l:irhs += 1
      endwhile

      if l:nlhs != l:nrhs
        return l:nlhs > l:nrhs ? 1 : -1
      endif
      if l:zlhs != l:zrhs
        return l:zlhs > l:zrhs ? 1 : -1
      endif
    else
      if a:lhs[l:ilhs] != a:rhs[l:irhs]
        return a:lhs[l:ilhs] > a:rhs[l:irhs] ? 1 : -1
      endif
      let l:ilhs += 1
      let l:irhs += 1
    endif
  endwhile

  return l:llhs == l:lrhs ? 0 : (l:llhs > l:lrhs ? 1 : -1)
endfunction

function! s:name(base, v) abort
  let l:type = a:v['type']
  if l:type ==# 'link' || l:type ==# 'junction'
    if isdirectory(resolve(a:base .. a:v['name']))
      let l:type = 'dir'
    endif
  elseif l:type ==# 'linkd'
    let l:type = 'dir'
  endif
  return a:v['name'] .. (l:type ==# 'dir' ? '/' : '')
endfunction

function! molder#chdir() abort
  if get(b:, 'molder_dir', '') ==# ''
    return
  endif
  noautocmd silent file `=getcwd()`
  call molder#init()
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

  let b:molder_dir = l:dir
  noautocmd noswapfile keepalt silent file `=b:molder_dir`
  setlocal modifiable
  setlocal filetype=molder buftype=nofile bufhidden=unload nobuflisted noswapfile
  setlocal nowrap cursorline
  if exists('*readdirex')
    let l:files = map(readdirex(l:path, '1', {'sort': 'none'}), {_, v -> s:name(l:dir, v)})
  else
    let l:files = map(readdir(l:path, '1'), {_, v -> s:name(l:dir, {'type': getftype(l:dir .. '/' .. v), 'name': v})})
  endif
  if !get(b:, 'molder_show_hidden', get(g:, 'molder_show_hidden', 0))
    call filter(l:files, 'v:val =~# "^[^.]"')
  endif
  let l:funcname = get(g:, 'molder_natural_sort', 0) ? 's:natural_sort' : 's:sort'
  let l:old_undolevels = &undolevels
  let &undolevels = -1
  silent keepmarks keepjumps call setline(1, sort(l:files, function(l:funcname)))
  let &undolevels = l:old_undolevels
  setlocal nomodified nomodifiable
  for l:fn in filter(split(execute('function'), "\n"), 'v:val =~# "^function molder#extension#\\w\\+#init().*"')
    call call(split(l:fn, ' ')[1][:-3], [])
  endfor
  let l:alt = fnamemodify(expand('#'), ':p:h:gs!\!/!')
  if substitute(l:dir, '/$', '', '') ==# l:alt
    let l:alt = fnamemodify(expand('#'), ':t')
    call search('\v^\V' .. escape(l:alt, '\') .. '\v$', 'c')
  endif
endfunction

function! molder#open() abort
  let l:split = getline('.') =~# '/$' ? 'edit' : get(g:, 'molder_open_split', 'edit')
  exe l:split fnameescape(b:molder_dir .. substitute(getline('.'), '/$', '', ''))
endfunction

function! molder#open_split() abort
endfunction

function! molder#up() abort
  let l:dir = substitute(b:molder_dir, '/$', '', '')
  let l:name = fnamemodify(l:dir, ':t:gs!\!/!')
  if empty(l:name)
    return
  endif
  let l:dir = fnamemodify(l:dir, ':p:h:h:gs!\!/!')
  exe 'edit' fnameescape(l:dir)
  call search('\v^\V' .. escape(l:name, '\') .. '/\v$', 'c')
endfunction

function! molder#home() abort
  exe 'edit' fnameescape(substitute(fnamemodify(expand('~'), ':p:gs!\!/!'), '/$', '', ''))
endfunction

function! molder#reload() abort
  edit
endfunction

function! molder#curdir() abort
  return get(b:, 'molder_dir', '')
endfunction

function! molder#current() abort
  return getline('.')
endfunction

function! molder#toggle_hidden() abort
  let b:molder_show_hidden = !get(b:, 'molder_show_hidden', get(g:, 'molder_show_hidden', 0))
  call molder#reload()
endfunction

function! molder#error(msg) abort
  redraw
  echohl Error
  echomsg a:msg
  echohl None
endfunction
