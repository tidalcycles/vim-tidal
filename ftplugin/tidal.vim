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

function! TidalSilence(channel)
  execute 'SlimeSend1 d' . a:channel . ' silence'
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-slime: custom mapping
xmap <buffer> <localleader>s  <Plug>SlimeRegionSend
nmap <buffer> <localleader>s  <Plug>SlimeLineSend
nmap <buffer> <localleader>ss <Plug>SlimeParagraphSend

" tidal: hush
nmap <buffer> <localleader>zz :<c-u>call TidalHush()<cr>

" tidal: silence for each channel
let c = 1
while c <= 9
  execute 'nmap <buffer> <localleader>z'.c.' :<c-u>call TidalSilence('.c.')<cr>'
  let c += 1
endwhile
