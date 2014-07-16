""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! TidalHush()
  execute 'SlimeSend1 hush'
endfunction

function! TidalSilence(stream)
  execute 'SlimeSend1 d' . a:stream . ' silence'
endfunction

function! TidalPlay(stream)
  let res = search('^\s*d' . a:stream)
  if res > 0
    execute "normal! vip:SlimeSend\<cr>"
  else
    echo "d" . a:stream . " was not found"
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=0 TidalHush call TidalHush()
command! -nargs=1 TidalSilence call TidalSilence(<args>)
command! -nargs=1 TidalPlay call TidalPlay(<args>)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Configuration
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-slime global options
let g:slime_target="tmux"
let g:slime_paste_file=tempname()
let g:slime_default_config={"socket_name": "default", "target_pane": "tidal:0.1"}
let g:slime_no_mappings=1
