""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let s:not_prefixable_keywords = [ "import", "data", "instance", "class", "{-#", "type", "case", "do", "let", "default", "foreign", "--"]

" guess correct number of spaces to indent
" (tabs are not allowed)
function! Get_indent_string()
    return repeat(" ", 4)
endfunction

" replace tabs by spaces
function! Tab_to_spaces(text)
    return substitute(a:text, "	", Get_indent_string(), "g")
endfunction

" Wrap in :{ :} if there's more than one line
function! Wrap_if_multi(lines)
    if len(a:lines) > 1
        return [":{"] + a:lines + [":}"]
    else
        return a:lines
    endif
endfunction

" change string into array of lines
function! Lines(text)
    return split(a:text, "\n")
endfunction

" change lines back into text
function! Unlines(lines)
    return join(a:lines, "\n") . "\n"
endfunction

" vim slime handler
function! _EscapeText_tidal(text)
    let l:lines = Lines(Tab_to_spaces(a:text))
    let l:lines = Wrap_if_multi(l:lines)
    return Unlines(l:lines)
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists("g:tidal_no_mappings") || !g:tidal_no_mappings
  if !hasmapto('<Plug>TidalConfig', 'n')
    nmap <buffer> <localleader>c <Plug>TidalConfig
  endif

  if !hasmapto('<Plug>TidalRegionSend', 'x')
    xmap <buffer> <localleader>s  <Plug>TidalRegionSend
    xmap <buffer> <c-e> <Plug>TidalRegionSend
  endif

  if !hasmapto('<Plug>TidalLineSend', 'n')
    nmap <buffer> <localleader>s  <Plug>TidalLineSend
  endif

  if !hasmapto('<Plug>TidalParagraphSend', 'n')
    nmap <buffer> <localleader>ss <Plug>TidalParagraphSend
    nmap <buffer> <c-e> <Plug>TidalParagraphSend
  endif

  imap <buffer> <c-e> <Esc><Plug>TidalParagraphSend<Esc>i<Right>

  nnoremap <buffer> <localleader>h :TidalHush<cr>
  nnoremap <buffer> <c-h> :TidalHush<cr>
  let i = 1
  while i <= 9
    execute 'nnoremap <buffer> <localleader>'.i.'  :TidalSilence '.i.'<cr>'
    execute 'nnoremap <buffer> <c-'.i.'>  :TidalSilence '.i.'<cr>'
    execute 'nnoremap <buffer> <localleader>s'.i.' :TidalPlay '.i.'<cr>'
    let i += 1
  endwhile
endif
