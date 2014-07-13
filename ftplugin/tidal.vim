function! _EscapeText_haskell_tidal(text)
    let l:text  = Remove_block_comments(a:text)
    let l:lines = Lines(Tab_to_spaces(l:text))
    let l:lines = Remove_line_comments(l:lines)
    "let l:lines = Perhaps_prepend_let(l:lines)
    let l:lines = Indent_lines(l:lines)
    let l:lines = Wrap_if_multi(l:lines)
    return Unlines(l:lines)
endfunction
