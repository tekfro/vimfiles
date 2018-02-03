" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible


set autoindent	
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set copyindent                 " for pasting? can also try ":set paste"
set expandtab
set go=""
set guifont=consolas:h10
set history=50		           " keep 50 lines of command line history
set hlsearch
set incsearch		           " do incremental searching
set listchars+=precedes:<,extends:>
set nobackup		           " do not keep a backup file, use versions instead
set nowrap
set report=1
set ruler		               " show the cursor position all the time
set scrolloff=10               " keeps cursor in middle of screen
set shiftwidth=4
set showcmd		               " display incomplete commands
set showmode
set sidescroll=1
set sidescrolloff=20           " large values can cause jumpiness in narrow windows
set softtabstop=4
set splitbelow                 " control where split puts new windows
set splitright                 "   i like bottom or right better
set startofline
set tabstop=4

set grepprg=internal " this seems to be the only option that actually works on windows

colorscheme default

"---------------------------------------------------
" statusline
set laststatus=2
"set statusline=
"set statusline=%2*\ -\ %t%m%h%w%r\ -\ %1*%y%=\ <<\ %4.16(%1*%l-%L%),%3p%%\ >>\ %*

function! UpdateStatus() abort
    let inactiveStatus='%2* - %t%m%h%w%r - %1*%y%= << %4.16(%l-%L%),%3p%% >> %*'
    let activeStatus='%4* - %t%m%h%w%r - %3*%y%= << %4.16(%l-%L%),%3p%% >> %*'
    let w = winnr()
    for n in range(1, winnr('$'))
        call setwinvar(n, '&statusline', n!=w ? inactiveStatus : activeStatus)
    endfor
endfunction

augroup status
    autocmd!
    autocmd WinEnter,BufWinEnter,VimEnter * call UpdateStatus() 
augroup END

"--------------------------------------------------------------------
" binary mode commands
" ex command for toggling hex mode - define mapping if desired
command -bar Hexmode call ToggleHex()

" helper function to toggle hex mode
function ToggleHex()
  " hex mode should be considered a read-only operation
  " save values for modified and read-only for restoration later,
  " and clear the read-only flag for now
  let l:modified=&mod
  let l:oldreadonly=&readonly
  let &readonly=0
  let l:oldmodifiable=&modifiable
  let &modifiable=1
  if !exists("b:editHex") || !b:editHex
    " save old options
    let b:oldft=&ft
    let b:oldbin=&bin
    " set new options
    setlocal binary " make sure it overrides any textwidth, etc.
    let &ft="xxd"
    " set status
    let b:editHex=1
    " switch to hex editor
    %!xxd
  else
    " restore old options
    let &ft=b:oldft
    if !b:oldbin
      setlocal nobinary
    endif
    " set status
    let b:editHex=0
    " return to normal editing
    %!xxd -r
  endif
  " restore values for modified and read only state
  let &mod=l:modified
  let &readonly=l:oldreadonly
  let &modifiable=l:oldmodifiable
endfunction

" autocmds to automatically enter hex mode and handle file writes properly
" vim -b : edit binary using xxd-format!
augroup Binary
au!

" set binary option for all binary files before reading them
au BufReadPre *.bin,*.hex setlocal binary

" if on a fresh read the buffer variable is already set, it's wrong
au BufReadPost *
      \ if exists('b:editHex') && b:editHex |
      \   let b:editHex = 0 |
      \ endif

" convert to hex on startup for binary files automatically
au BufReadPost *
      \ if &binary | Hexmode | endif

" When the text is freed, the next time the buffer is made active it will
" re-read the text and thus not match the correct mode, we will need to
" convert it again if the buffer is again loaded.
au BufUnload *
      \ if getbufvar(expand("<afile>"), 'editHex') == 1 |
      \   call setbufvar(expand("<afile>"), 'editHex', 0) |
      \ endif

" before writing a file when editing in hex mode, convert back to non-hex
au BufWritePre *
      \ if exists("b:editHex") && b:editHex && &binary |
      \  let oldro=&ro | let &ro=0 |
      \  let oldma=&ma | let &ma=1 |
      \  silent exe "%!xxd -r" |
      \  let &ma=oldma | let &ro=oldro |
      \  unlet oldma | unlet oldro |
      \ endif

" after writing a binary file, if we're in hex mode, restore hex mode
au BufWritePost *
      \ if exists("b:editHex") && b:editHex && &binary |
      \  let oldro=&ro | let &ro=0 |
      \  let oldma=&ma | let &ma=1 |
      \  silent exe "%!xxd" |
      \  exe "set nomod" |
      \  let &ma=oldma | let &ro=oldro |
      \  unlet oldma | unlet oldro |
      \ endif
augroup END

"
"--------------------------------------------------------------------

" Don't use Ex mode, use Q for formatting
map Q gq

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

"--------------------------------------------------------------------
" general command mappings
"

" ctrl-u at end of word insertion capitalizes it
inoremap <c-u> <esc>bvwUea
" easy escape from insert
inoremap jk <esc>
" train myself to use jk
"inoremap <esc> <nop>
" use very magic expression with search
nnoremap / /\v

let maplocalleader = ","

" uppercase current word in normal mode
nnoremap <localleader>u vwU
" move to beginning and end of line, and replace H and L commands
nnoremap H ^
nnoremap <localleader>H :normal! H<cr>
nnoremap L $
nnoremap <localleader>L :normal! L<cr>
" quick wrap toggle
nnoremap <localleader>[ :setlocal wrap!<cr>
" toggle highlight trailing whitespace
nnoremap <localleader>w :call ToggleTrailingSpaces()<cr>

let g:trailing_spaces_visible = 0
function! ToggleTrailingSpaces()
    if g:trailing_spaces_visible
        match
        let g:trailing_spaces_visible = 0
    else
        match Error /\v\S\zs+\s+$/
        let g:trailing_spaces_visible = 1
    endif
endfunction

" unhighlight the last search
nnoremap <localleader>/ :nohlsearch<cr>
" toggle line numbers
nnoremap <localleader>n :setlocal number!<cr>
" toggle fold column
nnoremap <localleader>f :call ToggleFoldColumn()<cr>

function! ToggleFoldColumn()
    if &foldcolumn
        setlocal foldcolumn=0
    else
        setlocal foldcolumn=4
    endif
endfunction

"---------------------------------------------------------------
" python folding implementation
"  - custom implementation of indent folding, which includes
"    a line above a block of code (like function def line or
"    for loop line) as part of block fold
function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while current <= numlines
        if getline(current) =~? '\v\S'
            return current
        endif

        let current += 1
    endwhile

    return -2
endfunction

function! CustomIndentFold(lnum)
    if getline(a:lnum) =~? '\v^\s*$'
        return '-1'
    endif

    let this_indent = IndentLevel(a:lnum)
    let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

    if next_indent == this_indent
        return this_indent
    elseif next_indent < this_indent
        return this_indent
    elseif next_indent > this_indent
        return '>' . next_indent
    endif
endfunction

"---------------------------------------------
" file type customizations
"
" file type common commands
" <localleader>c - add single line comment at beginning of current line
" #i - abbreviation for import statement

" c and c++ files
augroup cfiletype
    autocmd!
    autocmd FileType cpp,c inoreabbrev <buffer> #i #include
    autocmd FileType cpp,c inoreabbrev <buffer> #d #define
    autocmd FileType cpp,c nnoremap <buffer> <localleader>c I//<esc>
    autocmd FileType cpp,c setlocal foldlevel=99
    autocmd FileType cpp,c setlocal foldcolumn=4
    autocmd FileType cpp,c setlocal foldmethod=syntax
augroup END

" python files
augroup pyfiletype
    autocmd!
    autocmd FileType python setlocal ts=80
    autocmd FileType python inoreabbrev <buffer> #i import
    autocmd FileType python nnoremap <buffer> <localleader>c I#<esc>
    autocmd FileType python setlocal foldlevel=99
    autocmd FileType python setlocal foldcolumn=4
    autocmd FileType python setlocal foldmethod=expr
    autocmd FileType python setlocal foldexpr=CustomIndentFold(v:lnum)
augroup END

" java files
augroup javafiletype
    autocmd!
    autocmd FileType java inoreabbrev <buffer> #i import
    autocmd FileType java nnoremap <buffer> <localleader>c I//<esc>
    autocmd FileType java setlocal foldmethod=syntax
    autocmd FileType java setlocal foldlevel=99
    autocmd FileType java setlocal foldcolumn=4
augroup END

" vimfiles
augroup vimfiletype
    autocmd!
    autocmd FileType vim nnoremap <buffer> <localleader>c I"<esc>
augroup END

" html
augroup htmlfiletype
    autocmd!
    autocmd FileType html nnoremap <buffer> <localleader>c I<!--<esc>
    autocmd FileType html highlight! link htmlEndTag htmlTag

    " the html syntax file discards javascript highlighting, 
    " these commands restore it
    autocmd FileType html highlight! link javascript Normal
    autocmd FileType html highlight! link javaScriptComment Comment
    autocmd FileType html highlight! link javaScriptLineComment Comment
    autocmd FileType html highlight! link javaScriptCommentTodo Todo
    autocmd FileType html highlight! link javaScriptSpecial Special
    autocmd FileType html highlight! link javaScriptStringS String
    autocmd FileType html highlight! link javaScriptStringD String
    autocmd FileType html highlight! link javaScriptCharacter Character
    autocmd FileType html highlight! link javaScriptSpecialCharacter javaScriptSpecial
    autocmd FileType html highlight! link javaScriptNumber javaScriptValue
    autocmd FileType html highlight! link javaScriptConditional Conditional
    autocmd FileType html highlight! link javaScriptRepeat Repeat
    autocmd FileType html highlight! link javaScriptBranch Conditional
    autocmd FileType html highlight! link javaScriptOperator Operator
    autocmd FileType html highlight! link javaScriptType Type
    autocmd FileType html highlight! link javaScriptStatement Statement
    autocmd FileType html highlight! link javaScriptFunction Function
    autocmd FileType html highlight! link javaScriptBraces Function
    autocmd FileType html highlight! link javaScriptError Error
    autocmd FileType html highlight! link javaScrParenError javaScriptError
    autocmd FileType html highlight! link javaScriptNull Keyword
    autocmd FileType html highlight! link javaScriptBoolean Boolean
    autocmd FileType html highlight! link javaScriptRegexpString String

    autocmd FileType html highlight! link javaScriptIdentifier Identifier
    autocmd FileType html highlight! link javaScriptLabel Label
    autocmd FileType html highlight! link javaScriptException Exception
    autocmd FileType html highlight! link javaScriptMessage Keyword
    autocmd FileType html highlight! link javaScriptGlobal Keyword
    autocmd FileType html highlight! link javaScriptMember Keyword
    autocmd FileType html highlight! link javaScriptDeprecated Exception 
    autocmd FileType html highlight! link javaScriptReserved Keyword
    autocmd FileType html highlight! link javaScriptDebug Debug
    autocmd FileType html highlight! link javaScriptConstant Label
augroup END

" misc file types
augroup miscfiletype
    autocmd!
    autocmd FileType text setlocal textwidth=78
    autocmd FileType sas colorscheme default
augroup END

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
endif

  " Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
    autocmd!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

