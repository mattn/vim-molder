nnoremap <plug>(molder-open) :<c-u>call molder#open()<cr>
nnoremap <plug>(molder-up) :<c-u>call molder#up()<cr>
nnoremap <plug>(molder-reload) :<c-u>call molder#reload()<cr>
nnoremap <plug>(molder-home) :<c-u>call molder#home()<cr>

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
