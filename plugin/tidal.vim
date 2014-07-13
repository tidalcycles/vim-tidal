autocmd BufRead,BufNewFile *.tidal setfiletype haskell.tidal

let g:slime_target="tmux"
let g:slime_paste_file=tempname()
let g:slime_default_config={"socket_name": "default", "target_pane": "tidal:0.1"}
