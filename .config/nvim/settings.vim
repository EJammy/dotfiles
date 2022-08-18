" installation notes:
" set g:gdrive_path for path to google drive (for vim wiki)

" hint: gf to go to file, /-->

" TODO:
" https://github.com/nanotee/nvim-lua-guide
" TOC?
"	fix for windows
"	compiling
"	set scripts for installing dotfiles
"	tree (Nerdtree or Fern)
"	telescope, startup screen
"	<cmd>
"
"	/usr/share/vim/vim82/defaults.vim

if empty(glob('~/tmp'))
	silent !mkdir ~/tmp
endif

let mapleader = ' '

map! fd <Esc>
map! jk <Esc>
map! kj <Esc>

map <c-s> <cmd>w<cr>
map! <c-s> <cmd>w<cr>
map <leader>s <C-s>

" open vimrc
command! SettingsLocal vsplit ~/.vimrc
command! Preference Settings
map <Leader>pp :Preference<CR>


command! Sudowrite :execute ':silent w !sudo tee % > /dev/null' | :edit!

" fold around brackets
map <Leader>zf zfa}

" yank to system clipboard
map <Leader>y gg"+yG<c-o>
map <leader>p "+p
vmap <Leader>y "+y

" buffers
map <leader>bn <cmd>bn<cr>
map <leader>bp <cmd>bp<cr>
map <leader>bd <cmd>bp \| bd #<cr>
map <leader>x <cmd>bp \| bd #<cr>

nmap <tab> <cmd>bn<CR>
nmap <s-tab> <cmd>bp<CR>

nnoremap <c-p> <tab>

" new undo block at period
" imap . .<c-g>u

nmap gh <plug>(YCMHover)

map <Leader>we <cmd>NvimTreeToggle<CR>
" map <Leader>we :NERDTreeToggle<CR>

" <c-/>
map <c-_> <plug>NERDCommenterToggle
map <Leader>/ <plug>NERDCommenterToggle


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

" clear highlights
map <leader>h <cmd>nohls<cr>

" --> Autocmd
augroup vimrc
	autocmd!
	" map this last so it activates without waiting
	" some plugins load at VimEnter and breaks :(. maybe try some on demand loading?
	" autocmd VimEnter * nmap <nowait> <leader> <cmd>WhichKey '<leader>'<cr>
	" autocmd VimEnter * vmap <nowait> <leader> <cmd>WhichKeyVisual '<leader>'<cr>

	" helps with rclone vfs mounts, otherwise vim throws 'file changed'
	" warning
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

" --> Plugins
" Install vim-plug if not found
if has('unix')
	if empty(glob('~/.vim/autoload/plug.vim'))
		silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
					\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	endif
endif

if has('win32')
	if empty(glob('$HOME/vimfiles/autoload/plug.vim'))
		silent !powershell.exe "iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |
					\ni $home/vimfiles/autoload/plug.vim -force"
	endif
endi


" Run PlugInstall if there are missing plugins
" autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
" 			\| PlugInstall --sync | source $MYVIMRC
" 			\| endif
 

set rtp+=/usr/bin/fzf
map \ <Plug>VimwikiNextLink

" --> Appearance

" fix color
set termguicolors

" don't highlight misspells
" set highlight-=P:SpellCap
" set highlight+=Pn

let g:tokyonight_style = 'night' " available: night, storm
let g:tokyonight_enable_italic = 0
colorscheme tokyonight
" colorscheme onedark
" colorscheme PaperColor

" note: background color of tokyonight is #a1a6df
let g:PaperColor_Theme_Options = {
			\   'theme': {
			\     'default': {
			\       'transparent_background': 1
			\     }
			\   }
			\ }

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


" --> Language specific
" TODO: autocmd
map <F9> :w<CR>:!./a.out<CR>
map <F8> :w<CR>:!clear && g++ -std=c++17 -Wall -Wshadow -fsanitize=undefined -fsanitize=address -D_GLIBCXX_DEBUG -g "%"<CR>
map <Leader>r <F9>1
map <F9>1 :w<CR>:!clear && ./a.out < in<CR>
map <F9>2 :w<CR>:!./a.out < in > out<CR>
map <F10> :w<CR>:!clear && g++ -std=c++17 -Wall -Wshadow -fsanitize=undefined -fsanitize=address -D_GLIBCXX_DEBUG -g "%" && echo "start" && ./a.out<CR>

" c++ fast typing
ab pb push_back
ab NN << '\n'

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
let g:goyo_width="80%"
let g:goyo_height="80%"
map <Leader>ff :Goyo<CR>
map <Leader>gg :Goyo<CR>

