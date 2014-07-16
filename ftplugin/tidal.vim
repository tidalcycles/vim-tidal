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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-slime: custom mapping
if !exists("g:tidal_no_mappings") || !g:tidal_no_mappings
  " Define custom Slime mappings if default are disabled
  if g:slime_no_mappings
    if !hasmapto('<Plug>SlimeRegionSend', 'x')
      xmap <buffer> <localleader>s  <Plug>SlimeRegionSend
    endif

    if !hasmapto('<Plug>SlimeLineSend', 'n')
      nmap <buffer> <localleader>s  <Plug>SlimeLineSend
    endif

    if !hasmapto('<Plug>SlimeParagraphSend', 'n')
      nmap <buffer> <localleader>ss <Plug>SlimeParagraphSend
    endif
  endif

  nnoremap <buffer> <localleader>h :TidalHush<cr>
  let i = 1
  while i <= 9
    execute 'nnoremap <buffer> <localleader>'.i.'  :TidalSilence '.i.'<cr>'
    execute 'nnoremap <buffer> <localleader>s'.i.' :TidalPlay '.i.'<cr>'
    let i += 1
  endwhile
endif
