function! _EscapeText_haskell_tidal(text)
    let l:text  = Remove_block_comments(a:text)
    let l:lines = Lines(Tab_to_spaces(l:text))
    let l:lines = Remove_line_comments(l:lines)
    let l:lines = Wrap_if_multi(l:lines)
    return Unlines(l:lines)
endfunction


xmap <buffer> <localleader>s  <Plug>SlimeRegionSend
nmap <buffer> <localleader>s  <Plug>SlimeLineSend
nmap <buffer> <localleader>ss <Plug>SlimeParagraphSend

" *hush* zzz...
nmap <buffer> <localleader>zz :<c-u>SlimeSend1 hush<cr>

" silence binding for each channel
let c = 1
while c <= 9
  execute 'nmap <buffer> <localleader>z'.c.' :<c-u>SlimeSend1 d'.c.' silence<cr>'
  let c += 1
endwhile
