nnoremap <silent> <plug>(molder-open) :<c-u>call molder#open()<cr>
nnoremap <silent> <plug>(molder-up) :<c-u>call molder#up()<cr>
nnoremap <silent> <plug>(molder-reload) :<c-u>call molder#reload()<cr>
nnoremap <silent> <plug>(molder-home) :<c-u>call molder#home()<cr>
nnoremap <silent> <plug>(molder-toggle-hidden) :<c-u>call molder#toggle_hidden()<cr>

if !hasmapto('<plug>(molder-open)')
  nmap <buffer> <cr> <plug>(molder-open)
endif
if !hasmapto('<plug>(molder-up)')
  nmap <buffer> - <plug>(molder-up)
endif
if !hasmapto('<plug>(molder-reload)')
  nmap <buffer> \\ <plug>(molder-reload)
endif
if !hasmapto('<plug>(molder-home)')
  nmap <buffer> ~ <plug>(molder-home)
endif
if !hasmapto('<plug>(molder-toggle-hidden)')
  nmap <buffer> + <plug>(molder-toggle-hidden)
endif
