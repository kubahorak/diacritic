if exists("g:loaded_diacritic") || &cp
  finish
endif
let g:loaded_diacritic = 1
" save the cpo
let s:keepcpo = &cpo
set cpo&vim

" TODO the first noop mapping seems useless
if !hasmapto('<Plug>Diacritic')
  map <unique> <leader>p <Plug>Diacritic
  nnoremap <leader>p :set operatorfunc=DiacriticOperator<cr>g@
  vnoremap <leader>p :<c-u>call DiacriticOperator(visualmode(), 1)<cr>
endif

" keyboard mapping
map <silent> <unique> <script> <Plug>Diacritic
 \ :set lz<CR>:call <SID>DiacriticTranslit()<CR>:set nolz<CR>

" range command
command! -range DiacriticTranslit <line1>,<line2>call <SID>DiacriticTranslit()

" range command function
fun! s:DiacriticTranslit()
  let input = getline('.')
  let fenc = &fileencoding
  if (fenc == "")
    let fenc = "utf-8"
  endif
  let output = system("iconv -f ".fenc." -t ascii//translit", input)
  call setline('.', output)
endfun

" operator function
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

  let fenc = &fileencoding
  if (fenc == "")
    let fenc = "utf-8"
  endif
  let @@ = system("iconv -f ".fenc." -t ascii//translit", @@)

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

" put back the cpo
let &cpo = s:keepcpo
unlet s:keepcpo
