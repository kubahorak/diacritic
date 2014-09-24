if exists("g:loaded_diacritic") || &cp
  finish
endif
let g:loaded_diacritic = 1
" Save the cpo
let s:keepcpo = &cpo
set cpo&vim


" TODO the first noop mapping seems useless
if !hasmapto('<Plug>Diacritic')
  map <unique> <leader>p <Plug>Diacritic
  nnoremap <leader>p :set operatorfunc=DiacriticOperator<cr>g@
  vnoremap <leader>p :<c-u>call DiacriticOperator(visualmode(), 1)<cr>
endif

" Keyboard mapping
map <silent> <unique> <script> <Plug>Diacritic
 \ :set lz<CR>:call <SID>DiacriticTranslit()<CR>:set nolz<CR>

" Range command
command! -range DiacriticTranslit <line1>,<line2>call <SID>DiacriticTranslit()

" Range command function
fun! s:DiacriticTranslit()
  let input = getline('.')
  let output = s:DiacriticTranslitIO(input)
  call setline('.', output)
endfun

" Operator function
fun! DiacriticOperator(type, ...)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  if a:0
    " Invoked from Visual mode, use gv command.
    silent exe "normal! gvy"
  elseif a:type == 'line'
    silent exe "normal! '[V']y"
  else
    silent exe "normal! `[v`]y"
  endif

  let @@ = s:DiacriticTranslitIO(@@)

  if a:0
    " To paste back to Visual mode, use gv command with block register.
    let reg_save_c = getreg("c")
    call setreg("c", @@, "b")
    silent exe 'normal! gv"cp'
    call setreg("c", reg_save_c)
  elseif a:type == 'line'
    silent exe "normal! '[V']p"
  else
    silent exe "normal! `[v`]p"
  endif

  let &selection = sel_save
  let @@ = reg_save
endfun

" Transliterates input to output
fun! s:DiacriticTranslitIO(input)
  let fenc = &fileencoding
  if (fenc == "")
    let fenc = "utf-8"
  endif
  return s:system("iconv -f ".fenc." -t ascii//translit", a:input)
endfun

" System call wrapper. Ignores second argument if it's empty.
fun! s:system(cmd, arg)
  if strlen(a:arg) == 0
    return system(a:cmd)
  else
    return system(a:cmd, a:arg)
  endif
endfun


" Put back the cpo
let &cpo = s:keepcpo
unlet s:keepcpo
