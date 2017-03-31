if exists("g:loaded_tidal") || &cp || v:version < 700
  finish
endif
let g:loaded_tidal = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tmux
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:TmuxSend(config, text)
  let l:prefix = "tmux -L " . shellescape(a:config["socket_name"])
  " use STDIN unless configured to use a file
  if !exists("g:tidal_paste_file")
    call system(l:prefix . " load-buffer -", a:text)
  else
    call s:WritePasteFile(a:text)
    call system(l:prefix . " load-buffer " . g:tidal_paste_file)
  end
  call system(l:prefix . " paste-buffer -d -t " . shellescape(a:config["target_pane"]))
endfunction

function! s:TmuxPaneNames(A,L,P)
  let format = '#{pane_id} #{session_name}:#{window_index}.#{pane_index} #{window_name}#{?window_active, (active),}'
  return system("tmux -L " . shellescape(b:tidal_config['socket_name']) . " list-panes -a -F " . shellescape(format))
endfunction

function! s:TmuxConfig() abort
  if !exists("b:tidal_config")
    let b:tidal_config = {"socket_name": "default", "target_pane": ":"}
  end

  let b:tidal_config["socket_name"] = input("tmux socket name: ", b:tidal_config["socket_name"])
  let b:tidal_config["target_pane"] = input("tmux target pane: ", b:tidal_config["target_pane"], "custom,<SNR>" . s:SID() . "_TmuxPaneNames")
  if b:tidal_config["target_pane"] =~ '\s\+'
    let b:tidal_config["target_pane"] = split(b:tidal_config["target_pane"])[0]
  endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Helpers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

function! s:WritePasteFile(text)
  " could check exists("*writefile")
  call system("cat > " . g:tidal_paste_file, a:text)
endfunction

function! s:_EscapeText(text)
  if exists("&filetype")
    let custom_escape = "_EscapeText_" . substitute(&filetype, "[.]", "_", "g")
    if exists("*" . custom_escape)
      let result = call(custom_escape, [a:text])
    end
  end

  " use a:text if the ftplugin didn't kick in
  if !exists("result")
    let result = a:text
  end

  " return an array, regardless
  if type(result) == type("")
    return [result]
  else
    return result
  end
endfunction

function! s:TidalGetConfig()
  if !exists("b:tidal_config")
    if exists("g:tidal_default_config")
      let b:tidal_config = g:tidal_default_config
    else
      call s:TidalDispatch('Config')
    end
  end
endfunction

function! s:TidalFlashVisualSelection()
  " Redraw to show current visual selection, and sleep
  redraw
  execute "sleep " . g:tidal_flash_duration . " m"
  " Then leave visual mode
  silent exe "normal! vv"
endfunction

function! s:TidalSendOp(type, ...) abort
  call s:TidalGetConfig()

  let sel_save = &selection
  let &selection = "inclusive"
  let rv = getreg('"')
  let rt = getregtype('"')

  if a:0  " Invoked from Visual mode, use '< and '> marks.
    silent exe "normal! `<" . a:type . '`>y'
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  elseif a:type == 'block'
    silent exe "normal! `[\<C-V>`]\y"
  else
    silent exe "normal! `[v`]y"
  endif

  call setreg('"', @", 'V')
  call s:TidalSend(@")

  " Flash selection
  if a:type == 'line'
    silent exe "normal! '[V']"
    call s:TidalFlashVisualSelection()
  endif

  let &selection = sel_save
  call setreg('"', rv, rt)

  call s:TidalRestoreCurPos()
endfunction

function! s:TidalSendRange() range abort
  call s:TidalGetConfig()

  let rv = getreg('"')
  let rt = getregtype('"')
  silent execute a:firstline . ',' . a:lastline . 'yank'
  call s:TidalSend(@")
  call setreg('"', rv, rt)
endfunction

function! s:TidalSendLines(count) abort
  call s:TidalGetConfig()

  let rv = getreg('"')
  let rt = getregtype('"')

  silent execute "normal! " . a:count . "yy"

  call s:TidalSend(@")
  call setreg('"', rv, rt)

  " Flash lines
  silent execute "normal! V"
  if a:count > 1
    silent execute "normal! " . (a:count - 1) . "\<Down>"
  endif
  call s:TidalFlashVisualSelection()
endfunction

function! s:TidalStoreCurPos()
  if g:tidal_preserve_curpos == 1
    if exists("*getcurpos")
      let s:cur = getcurpos()
    else
      let s:cur = getpos('.')
    endif
  endif
endfunction

function! s:TidalRestoreCurPos()
  if g:tidal_preserve_curpos == 1
    call setpos('.', s:cur)
  endif
endfunction

let s:parent_path = fnamemodify(expand("<sfile>"), ":p:h:s?/plugin??")

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Public interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! s:TidalSend(text)
  call s:TidalGetConfig()

  let pieces = s:_EscapeText(a:text)
  for piece in pieces
    call s:TidalDispatch('Send', b:tidal_config, piece)
  endfor
endfunction

function! s:TidalConfig() abort
  call inputsave()
  call s:TidalDispatch('Config')
  call inputrestore()
endfunction

" delegation
function! s:TidalDispatch(name, ...)
  let target = substitute(tolower(g:tidal_target), '\(.\)', '\u\1', '') " Capitalize
  return call("s:" . target . a:name, a:000)
endfunction

function! s:TidalHush()
  execute 'TidalSend1 hush'
endfunction

function! s:TidalSilence(stream)
  silent execute 'TidalSend1 d' . a:stream . ' silence'
endfunction

function! s:TidalPlay(stream)
  let res = search('^\s*d' . a:stream)
  if res > 0
    silent execute "normal! vip:TidalSend\<cr>"
    silent execute "normal! vip"
    call s:TidalFlashVisualSelection()
  else
    echo "d" . a:stream . " was not found"
  endif
endfunction

function! s:TidalGenerateCompletions(path)
  let l:exe = s:parent_path . "/bin/generate-completions"
  let l:output_path = s:parent_path . "/.dirt-samples"

  if !empty(a:path)
    let l:sample_path = a:path
  else
    if has('macunix')
      let l:sample_path = "~/Library/Application Support/SuperCollider/downloaded-quarks/Dirt-Samples"
    elseif has('unix')
      let l:sample_path = "~/.local/share/SuperCollider/downloaded-quarks/Dirt-Samples"
    endif
  endif
  " generate completion file
  silent execute '!' . l:exe shellescape(expand(l:sample_path)) shellescape(expand(l:output_path))
  echo "Generated dictionary of dirt-samples"
  " setup completion
  let &l:dictionary .= ',' . l:output_path
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Setup key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

command -bar -nargs=0 TidalConfig call s:TidalConfig()
command -range -bar -nargs=0 TidalSend <line1>,<line2>call s:TidalSendRange()
command -nargs=+ TidalSend1 call s:TidalSend(<q-args> . "\r")

command! -nargs=0 TidalHush call s:TidalHush()
command! -nargs=1 TidalSilence call s:TidalSilence(<args>)
command! -nargs=1 TidalPlay call s:TidalPlay(<args>)
command! -nargs=? TidalGenerateCompletions call s:TidalGenerateCompletions(<q-args>)

noremap <SID>Operator :<c-u>call <SID>TidalStoreCurPos()<cr>:set opfunc=<SID>TidalSendOp<cr>g@

noremap <unique> <script> <silent> <Plug>TidalRegionSend :<c-u>call <SID>TidalSendOp(visualmode(), 1)<cr>
noremap <unique> <script> <silent> <Plug>TidalLineSend :<c-u>call <SID>TidalSendLines(v:count1)<cr>
noremap <unique> <script> <silent> <Plug>TidalMotionSend <SID>Operator
noremap <unique> <script> <silent> <Plug>TidalParagraphSend <SID>Operatorip
noremap <unique> <script> <silent> <Plug>TidalConfig :<c-u>TidalConfig<cr>

""
" Default options
"
if !exists("g:tidal_target")
  let g:tidal_target = "tmux"
endif

if !exists("g:tidal_paste_file")
  let g:tidal_paste_file = tempname()
endif

if !exists("g:tidal_default_config")
  let g:tidal_default_config = { "socket_name": "default", "target_pane": ":0.1" }
endif

if !exists("g:tidal_preserve_curpos")
  let g:tidal_preserve_curpos = 1
end

if !exists("g:tidal_flash_duration")
  let g:tidal_flash_duration = 150
end

if filereadable(s:parent_path . "/.dirt-samples")
  let &l:dictionary .= ',' . s:parent_path . "/.dirt-samples"
endif
