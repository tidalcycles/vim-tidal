autocmd BufRead,BufNewFile *.tidal setfiletype haskell.tidal

let g:slime_target="tmux"
let g:slime_paste_file=tempname()
let g:slime_default_config={"socket_name": "default", "target_pane": "tidal:0.1"}

let g:slime_no_mappings=1

autocmd FileType haskell.tidal xmap <buffer> <localleader>s  <Plug>SlimeRegionSend
autocmd FileType haskell.tidal nmap <buffer> <localleader>s  <Plug>SlimeLineSend
autocmd FileType haskell.tidal nmap <buffer> <localleader>ss <Plug>SlimeParagraphSend
