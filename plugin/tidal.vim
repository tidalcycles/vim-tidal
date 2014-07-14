autocmd BufRead,BufNewFile *.tidal setfiletype haskell.tidal

let g:slime_target="tmux"
let g:slime_paste_file=tempname()
let g:slime_default_config={"socket_name": "default", "target_pane": "tidal:0.1"}

let g:slime_no_mappings=1

autocmd FileType haskell.tidal xmap <buffer> <localleader>s  <Plug>SlimeRegionSend
autocmd FileType haskell.tidal nmap <buffer> <localleader>s  <Plug>SlimeLineSend
autocmd FileType haskell.tidal nmap <buffer> <localleader>ss <Plug>SlimeParagraphSend

" *hush* zzz...
autocmd FileType haskell.tidal nmap <buffer> <localleader>zz :<c-u>SlimeSend1 hush<cr>
autocmd FileType haskell.tidal nmap <buffer> <localleader>1  :<c-u>SlimeSend1 d1 silence<cr>
autocmd FileType haskell.tidal nmap <buffer> <localleader>2  :<c-u>SlimeSend1 d2 silence<cr>
autocmd FileType haskell.tidal nmap <buffer> <localleader>3  :<c-u>SlimeSend1 d3 silence<cr>
autocmd FileType haskell.tidal nmap <buffer> <localleader>4  :<c-u>SlimeSend1 d4 silence<cr>
autocmd FileType haskell.tidal nmap <buffer> <localleader>5  :<c-u>SlimeSend1 d5 silence<cr>
autocmd FileType haskell.tidal nmap <buffer> <localleader>6  :<c-u>SlimeSend1 d6 silence<cr>
autocmd FileType haskell.tidal nmap <buffer> <localleader>7  :<c-u>SlimeSend1 d7 silence<cr>
autocmd FileType haskell.tidal nmap <buffer> <localleader>8  :<c-u>SlimeSend1 d8 silence<cr>
