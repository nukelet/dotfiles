" Only load this plugin it has not yet been loaded for this buffer
if exists("b:did_myvimtexsettings")
  finish
endif
let b:did_myvimtexsettings = 1

let g:vimtex_view_enabled = 1
let g:vimtex_view_method = 'zathura'


let g:vimtex_compiler_latexmk = {
    \ 'build_dir' : '',
    \ 'callback' : 1,
    \ 'continuous' : 0,
    \ 'executable' : 'latexmk',
    \ 'hooks' : [],
    \ 'options' : [
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \   '-shell-escape'
    \ ],
    \}

