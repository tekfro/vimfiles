" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=4 sw=4
" Vim color file
" Maintainer:    Ron Aaron <ron@ronware.org>
" Last Change:    2003 May 02

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "default"
"silver    #CCCCCC
"gray      #999999
"green     #669966
"babyblue  #99CCFF
"blue      #3366FF
"orange    #FF9933
"dark pink #FF00FF
"yellow    #FFFF00
"purple    #CC33FF
"darblue   #0033CC

hi! Normal            ctermfg=white ctermbg=black guifg=#FFFFFF guibg=#000000

hi! IncSearch         ctermfg=blue ctermbg=black guifg=#99CCFF guibg=#000000
hi! Search            ctermbg=darkmagenta ctermfg=black guibg=#FF00FF guifg=#000000

hi! Cursor            ctermbg=yellow ctermfg=black guibg=#FFFF00 guifg=#000000
hi! link lCursor Cursor
hi! link MatchParen Cursor

hi! Comment           ctermfg=darkblue cterm=bold guifg=#3366FF gui=bold

hi! Constant          ctermfg=darkgreen cterm=bold guifg=#669966 gui=bold
hi! link Character    Constant
hi! link Boolean      Constant
hi! link String       Constant
hi! link SpecialChar  Constant
hi! link Number       Constant
hi! link Float        Constant

hi! Keyword           ctermfg=darkgray guifg=#999999

hi! Special           ctermfg=darkmagenta guifg=#CC33FF
hi! SpecialComment    ctermfg=darkmagenta guifg=#CC33FF

hi! Tag               ctermfg=red guifg=#FF0000
hi! Debug             ctermfg=red guifg=#FF0000

hi! Delimiter         ctermfg=white cterm=bold guifg=#FFFFFF gui=bold
hi! Operator          ctermfg=darkgray cterm=bold guifg=#999999 gui=bold

hi! Identifier        ctermfg=darkblue cterm=bold guifg=#0033CC gui=bold

hi! Statement         ctermfg=grey guifg=#CCCCCC
hi! link Label        Statement
hi! link Exception    Statement

hi! Macro             ctermfg=white guifg=#FFFFFF

hi! PreProc           ctermfg=grey cterm=bold guifg=#CCCCCC gui=bold
hi! link Define       PreProc
hi! link Include      PreProc
hi! link PreCondit    PreProc

hi! Type              ctermfg=darkgrey guifg=#999999
hi! link StorageClass Type
hi! link Structure    Type
hi! link Typedef      Type

hi! Function          ctermfg=darkgrey cterm=bold guifg=#999999 gui=bold

hi! Repeat            ctermfg=grey guifg=#CCCCCC
hi! link Conditional  Repeat

hi! Ignore            ctermfg=grey guifg=#CCCCCC
hi! Error             ctermfg=white ctermbg=red guifg=#FFFFFF guibg=#FF0000
hi! Todo              ctermfg=darkcyan ctermbg=yellow guifg=#3333FF guibg=#FFFF00
hi! SpecialKey        ctermfg=darkblue cterm=bold guifg=#3333FF
hi! Directory         ctermfg=darkblue guifg=#99CCFF
hi! Title             ctermfg=darkblue cterm=bold guifg=#3366FF gui=bold

hi! Visual            ctermfg=black ctermbg=lightblue guifg=#000000 guibg=#99CCFF

hi! Folded            ctermbg=brown ctermbg=black guifg=#FF9933 guibg=#000000
hi! FoldColumn        ctermfg=brown ctermbg=black guifg=#FF9933 guibg=#000000

hi! TabLine           ctermbg=grey ctermfg=black guibg=#CCCCCC guifg=#000000
hi! TabLineSel        ctermbg=blue ctermbg=black guibg=#99CCFF guifg=#000000
hi! TabLineFill       ctermfg=darkgray ctermbg=black guifg=#333333 guibg=#000000

hi! VertSplit         ctermfg=darkgrey ctermbg=white guifg=#333333 guibg=#CCCCCC

hi! LineNr            ctermfg=darkmagenta guifg=#6600CC

hi! NonText           ctermfg=green guifg=#00FF00

hi! User1             ctermfg=darkgrey cterm=bold guifg=#666666 gui=bold
hi! User2             ctermbg=darkgrey ctermfg=black guibg=#666666 guifg=#000000
hi! User3             ctermfg=white cterm=bold guifg=#CCCCCC gui=bold
hi! User4             ctermbg=white ctermbg=black guibg=#CCCCCC guifg=#000000
