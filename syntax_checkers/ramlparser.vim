"============================================================================
"File:        ramlparser.vim
"Description: raml syntax checker - using raml-parser
"Maintainer:  umezo
"License:     This program is free software. It comes without any warranty,
"             to the extent permitted by applicable law. You can redistribute
"             it and/or modify it under the terms of the Do What The Fuck You
"             Want To Public License, Version 2, as published by Sam Hocevar.
"             See http://sam.zoy.org/wtfpl/COPYING for more details.
"============================================================================

if exists('g:loaded_syntastic_raml_ramlparser_checker')
    finish
endif
let g:loaded_syntastic_raml_ramlparser_checker = 1

"if !exists('g:syntastic_raml_ramlparser_sort')
"    let g:syntastic_raml_ramlparser_sort = 1
"endif

let s:save_cpo = &cpo
set cpo&vim

function! SyntaxCheckers_raml_ramlparser_IsAvailable() dict
    call syntastic#log#deprecationWarn('ramlparser_exec', 'raml_ramlparser_exec')
    if !executable(self.getExec())
        return 0
    endif

    let ver = self.getVersion()
    let s:ramlparser_new = syntastic#util#versionIsAtLeast(ver, [1, 1])

    return syntastic#util#versionIsAtLeast(ver, [1])
endfunction

function! SyntaxCheckers_raml_ramlparser_GetLocList() dict
    "call syntastic#log#deprecationWarn('raml_ramlparser_conf', 'raml_ramlparser_args', "'--config ' . syntastic#util#shexpand(OLD_VAR)")

    let makeprg = self.makeprgBuild({ 'args_after': (s:ramlparser_new ? '--verbose ' : '') })

    let errorformat = s:ramlparser_new ?
        \ '%A%f: line %l\, col %v\, %m \(%t%*\d\)' :
        \ '%E%f: line %l\, col %v\, %m'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'defaults': {'bufnr': bufnr('')},
        \ 'returns': [0, 2] })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'raml',
    \ 'exec': 'raml-parser',
    \ 'name': 'ramlparser'})

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
