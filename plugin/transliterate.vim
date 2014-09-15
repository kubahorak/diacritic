if exists("g:loaded_transliterate") || &cp
  finish
endif
let g:loaded_transliterate = 1
" save the cpo
let s:keepcpo = &cpo
set cpo&vim

if !hasmapto('<Plug>Transliterate')
  map <unique> <Leader>p <Plug>Transliterate
endif

" keyboard mapping
map <silent> <unique> <script> <Plug>Transliterate
 \ :set lz<CR>:call <SID>Transliterate()<CR>:set nolz<CR>

" range command
command! -range Transliterate <line1>,<line2>call <SID>Transliterate()

fun! s:Transliterate()
  let input = getline('.')
  let fenc = &fileencoding
  let output = system("iconv -f ".fenc." -t latin1//translit", input)
  call setline('.', output)
endfun

" put back the cpo
let &cpo = s:keepcpo
unlet s:keepcpo
