""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Tidal custom escape function for vim-slime
function! _EscapeText_haskell_tidal(text)
  let text  = Remove_block_comments(a:text)
  let lines = Lines(Tab_to_spaces(text))
  let lines = Remove_line_comments(lines)
  let lines = Wrap_if_multi(lines)
  return Unlines(lines)
endfunction

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
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-slime: custom mapping
xmap <buffer> <localleader>s  <Plug>SlimeRegionSend
nmap <buffer> <localleader>s  <Plug>SlimeLineSend
nmap <buffer> <localleader>ss <Plug>SlimeParagraphSend

nmap <buffer> <localleader>h :<c-u>call TidalHush()<cr>

let i = 1
while i <= 9
  execute 'nmap <buffer> <localleader>s'.i.'  :<c-u>call TidalPlay('.i.')<cr>'
  execute 'nmap <buffer> <localleader>'.i.' :<c-u>call TidalSilence('.i.')<cr>'
  let i += 1
endwhile
