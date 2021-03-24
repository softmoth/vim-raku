" Vim filetype plugin file
" Language:      Raku
" Maintainer:    vim-perl <vim-perl@googlegroups.com>
" Homepage:      https://github.com/vim-perl/vim-perl6
" Bugs/requests: https://github.com/vim-perl/vim-perl6/issues
" Last Change:   {{LAST_CHANGE}}
" Contributors:  Hinrik Örn Sigurðsson <hinrik.sig@gmail.com>
"
" Based on ftplugin/perl.vim by Dan Sharp <dwsharp at hotmail dot com>

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
let s:save_cpo = &cpo
set cpo-=C

setlocal formatoptions-=t
setlocal formatoptions+=crqol
setlocal keywordprg=p6doc

setlocal comments=:#\|,:#=,:#
setlocal commentstring=#%s

" Provided by Ned Konz <ned at bike-nomad dot com>
"---------------------------------------------
setlocal include=\\<\\(use\\\|require\\)\\>
setlocal includeexpr=substitute(v:fname,'::','/','g')
setlocal suffixesadd=.rakumod,.rakudoc,.pm6,.pm
setlocal define=[^A-Za-z_]

" The following line changes a global variable but is necessary to make
" gf and similar commands work. Thanks to Andrew Pimlott for pointing out
" the problem. If this causes a " problem for you, add an
" after/ftplugin/raku.vim file that contains
"       set isfname-=:
set isfname+=:
setlocal iskeyword=@,48-57,_,192-255,-

" Raku exposes its CompUnits through $*REPO, but mapping module names to
" compunit paths is nontrivial. Probably it's more convenient to rely on
" people using zef, which has a handy store of sources for modules it has
" installed.
func s:compareReverseFtime(a, b)
    let atime = getftime(a:a)
    let btime = getftime(a:b)
    return atime > btime ? -1 : atime == btime ? 0 : 1
endfunc

let &l:path = "lib,."
if exists('$RAKULIB')
    let &l:path = &l:path . "," . $RAKULIB
endif
let &l:path = &l:path . "," . join(
            \ sort(glob("~/.zef/store/*/*/lib", 0, 1), "s:compareReverseFtime"),
            \ ',')

" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal fo< com< cms< inc< inex< def< isf< isk< kp< path<" .
        \         " | unlet! b:browsefilter"

" Restore the saved compatibility options.
let &cpo = s:save_cpo
unlet s:save_cpo
