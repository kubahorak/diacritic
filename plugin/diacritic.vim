if exists("g:loaded_diacritic") || &cp
  finish
endif
let g:loaded_diacritic = 1
" save the cpo
let s:keepcpo = &cpo
set cpo&vim

if !hasmapto('<Plug>Diacritic')
  map <unique> <Leader>p <Plug>Diacritic
endif

" keyboard mapping
map <silent> <unique> <script> <Plug>Diacritic
 \ :set lz<CR>:call <SID>DiacriticTranslit()<CR>:set nolz<CR>

" range command
command! -range DiacriticTranslit <line1>,<line2>call <SID>DiacriticTranslit()

fun! s:DiacriticTranslit()
  let input = getline('.')
  let fenc = &fileencoding
  if (fenc == "")
    let fenc = "utf-8"
  endif
  let output = system("iconv -f ".fenc." -t ascii//translit", input)
  call setline('.', output)
endfun

" put back the cpo
let &cpo = s:keepcpo
unlet s:keepcpo
