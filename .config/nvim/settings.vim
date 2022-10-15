
" VimTeX
"
" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
" let g:vimtex_view_method = 'zathura'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
let maplocalleader = " "





let mapleader = ' '

command! Sudowrite :execute ':silent w !sudo tee % > /dev/null' | :edit!

autocmd BufRead * autocmd FileType <buffer> ++once
  \ if &ft !~# 'commit\|rebase' && line("'\"") > 1 && line("'\"") <= line("$") | exe 'normal! g`"' | endif


" blogging with hugo
function! FHugoNewPost(name)
	exec '!hugo new content/post/' . a:name . '.md'
	exec 'e content/post/' . a:name . '.md'
endfunc

command! -nargs=1 HugoNewPost call FHugoNewPost('<args>')

" vim-fzf
map <leader><leader><leader> :Commands<CR>
map <leader><leader>p :Commands<CR>
map <Leader><Leader>c :Colors<CR>
map <Leader><Leader>f :Buffers<CR>


" --> Autocmd
augroup vimrc
	autocmd!
	" map this last so it activates without waiting
	" some plugins load at VimEnter and breaks :(. maybe try some on demand loading?
	" autocmd VimEnter * nmap <nowait> <leader> <cmd>WhichKey '<leader>'<cr>
	" autocmd VimEnter * vmap <nowait> <leader> <cmd>WhichKeyVisual '<leader>'<cr>

	" helps with rclone vfs mounts, otherwise vim throws 'file changed' warning
	autocmd BufLeave * up
	autocmd BufWritePost * checktime

	autocmd InsertEnter *
			\ if bufname() != "[Command line]" | checktime | endif
	autocmd CursorMoved *
			\ if bufname() != "[Command line]" | checktime | endif
augroup END

if has('nvim')
	command! ReloadConfig source ~/.config/nvim/init.lua
else
	command! ReloadConfig source ~/.vimrc
endif


" Run PlugInstall if there are missing plugins
" autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
" 			\| PlugInstall --sync | source $MYVIMRC
" 			\| endif
 

set rtp+=/usr/bin/fzf
map \ <Plug>VimwikiNextLink

" --> Appearance

" don't highlight misspells
" set highlight-=P:SpellCap
" set highlight+=Pn

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 0
colorscheme tokyonight
" colorscheme onedark
" colorscheme PaperColor
" colorscheme catppuccin

" note: background color of tokyonight is #a1a6df
" let g:PaperColor_Theme_Options = {
"             \   'theme': {
"             \     'default': {
"             \       'transparent_background': 1
"             \     }
"             \   }
"             \ }

func! SetTransparentBackground(val)
	let g:PaperColor_Theme_Options.theme.default.transparent_background = a:val
	let g:tokyonight_transparent_background = a:val
	exe "colorscheme" g:colors_name
	mode
endfunc

let g:transparent_background=0
command! ToggleBackground
			\ let g:transparent_background=!g:transparent_background |
			\ call SetTransparentBackground(g:transparent_background)
map <Leader>bb :ToggleBackground<CR>

" gui settings (some of these have problem in neovide

" Laggy
" set guifont=Cascadia\ Code:h12

" the characters [] misalign
" set guifont=Noto\ Sans\ Mono:h11

set guifont=Liberation\ Mono:h11
if has('gui_running') || exists('g:GtkGuiLoaded')
	" if has('gui_gtk')
		set guifont=Cascadia\ Code:h12
	" else
	"     set guifont=Cascadia_Mono:h12:cANSI:qDRAFT,
	" endif
	set lines=40
	set columns=170
	set background=dark
	set guioptions=gm " default: egmrLtT
endif

map <Leader>f1 <cmd>set guifont=Liberation\ Mono:h11<cr>
map <Leader>f2 <cmd>set guifont=Noto\ Looped\ Lao:h12<cr>
map <Leader>f3 <cmd>set guifont=Noto\ Sans\ Mono:h11<cr>

" neovide
func! SetNeovideTransparency(val)
	if a:val
		let g:neovide_transparency=0.95
	else
		let g:neovide_transparency=1
	endif
	mode
endfunc

let g:neovide_transparency=0.95

" let g:neovide_cursor_vfx_mode = "pixiedust"
let g:neovide_cursor_vfx_mode = "railgun"
let g:neovide_cursor_vfx_particle_density=200
let g:neovide_cursor_vfx_particle_speed=10
let g:neovide_cursor_vfx_particle_lifetime=0.6

map <F11> :let g:neovide_fullscreen=!g:neovide_fullscreen<CR>
let g:neovide_remember_window_size=v:false


" --> Sessions
if empty(glob('~/.vim/sessions/'))
	silent !mkdir ~/.vim/sessions/
endif

" set sessionoptions=blank,curdir,folds,help,options,tabpages,winsize,terminal
map <F5> :mks! ~/.vim/sessions/
map <F6> :source ~/.vim/sessions/

augroup session
	autocmd!
	autocmd VimLeave * mks! ~/.vim/sessions/lastClosed
augroup END
" autocmd VimEnter * source ~/vimfiles/sessions/lastClosed


" --> Plugins
" vimwiki
if exists('g:gdrive_path')
	" vimwiki settings
	let g:vimwiki_list = [{'path': g:gdrive_path . 'vimwiki/',
				\ 'syntax': 'markdown', 'ext': '.md'}]
endif

" NERD commenting
let g:NERDDefaultAlign='left'
let g:NERDSpaceDelims=1

" goyo (focus mode) settings

