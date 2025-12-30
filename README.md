# vim-molder

Minimal File Explorer

![](https://raw.githubusercontent.com/mattn/vim-molder/master/misc/screenshot1.gif)

![](https://raw.githubusercontent.com/mattn/vim-molder/master/misc/screenshot2.gif)

## Usage

```
$ vim /path/to/directory/
```

## Installation

For [vim-plug](https://github.com/junegunn/vim-plug) plugin manager:

```vim
Plug 'mattn/vim-molder'
```

## Extensions

vim-molder does not have features to operate file or directories. You need to add [vim-molder-operations](https://github.com/mattn/vim-molder-operations) if you want to do it.

```vim
Plug 'mattn/vim-molder'
Plug 'mattn/vim-molder-operations'
```

## Custom Handlers

You can add custom protocol handlers by implementing `molder#handler#<name>#init(path)` function. The handler should return the local path if it handles the protocol, or empty string otherwise.

Example for ssh:// protocol:

```vim
function! molder#handler#ssh#init(path) abort
  if a:path !~# '^ssh://'
    return ''
  endif
  " Parse ssh:// URL and return local mount point
  " return '/tmp/sshfs/user@host/path'
  return {'dir': '/path/to', 'files': ['file1', 'file2']}
endfunction
```

## Options

* Show dotfiles and dotdirs:

    ````vim
    let g:molder_show_hidden = 1
    ````

## License

MIT

## Author

Yasuhiro Matsumoto
