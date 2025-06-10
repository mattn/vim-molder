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
