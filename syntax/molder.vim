if exists('b:current_syntax')
  finish
endif

syn match molderDirectory '^.\+/$'

hi! def link molderDirectory Directory

let b:current_syntax = 'molder'

