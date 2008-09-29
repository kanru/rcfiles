" Prevent modelines in files from being evaluated (avoids a potential
" " security problem wherein a malicious user could write a hazardous
" " modeline into a file) (override default value of 5)
set modeline

" Performance
set nofsync
set sws=""
"set nu
let &guicursor = &guicursor . ",a:blinkon0"
set guioptions-=T
set guioptions-=m
set guioptions-=e
set guioptions-=r
" Tab
set showtabline=1
set expandtab
set smarttab
set smartcase
set shiftwidth=4
set softtabstop=4
set tabstop=4
set ignorecase
set nobackup
set writebackup
set nocompatible      " We're running Vim, not Vi!
set backspace=indent,eol,start  " more powerful backspacing
set autoindent          " always set autoindenting on
set smartindent
set lz
set sj=-50
set viminfo='20,\"50    " read/write a .viminfo file, don't store more than
                        " 50 lines of registers
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
"set hls
set incsearch
"set wildmenu
"set wim=longest:full
set gfn=Bitstream\ Vera\ Sans\ Mono\ 10,DFLiHeiStd\ W5\ 13
set makeprg=g++\ -o\ %<\ % 
set showcmd
set showmatch
set fileencodings=utf-8,iso8859-1,utf16le,gb2312,big5,latin1,gbk,euc-jp,euc-kr,utf32,utf-bom
set encoding=utf8
set tenc=utf8
syntax on             " Enable syntax highlighting
if $COLORTERM == 'roxterm'
    set term=gnome-256color
    colorscheme railscasts
elseif has("gui_running")
    colorscheme railscasts
else
    colorscheme default
endif 
"set t_Co=256
"colorscheme desert256
"if has("gui_running")
"    set bg=light
"else
"    set bg=dark
"endif
"hi LineNr guibg=lightgray

let g:tex_flavor = "latex"

" set commandline
cnoremap <C-A> <Home>
cnoremap <C-F> <Right>
cnoremap <C-B> <Left>

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
filetype on           " Enable fieltype detection
if has("autocmd")
	" Enabled file type detection
	" Use the default filetype settings. If you also want to load indent files
	" to automatically do language-dependent indenting add 'indent' as well.
	filetype plugin on
	filetype indent on    " Enable filetype-specific indentin
endif " has("autocmd")
" Make p in Visual mode replace the selected text with the "" register.
vnoremap p <Esc>:let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>
" Some Debian-specific things
augroup filetype
	au BufRead reportbug.* set ft=mail
	au BufRead reportbug-* set ft=mail
	au BufRead *.p6	set ft=perl6
augroup END

"colorscheme tango
"colorscheme vibrant-ink
"使用 :update 代替 :w，以便在有修改時才會存檔，注意，這和 vi 不相容。
map tn gt
map tp gT
map <F2> :up<CR>
"map <F2> :set fileencoding=big5<CR>
"map <F3> :up<CR>:q<CR>    " 存檔後離開
"map <F3> :set fileencoding=utf8<CR>
map <F3> <ESC>:up<CR>:silent !xelatex -interaction=batchmode main.tex &<CR>:redraw!<CR>
"map <F4> :q!<CR>    " 不存檔離開
"map <F5> :bp<CR>    " 前一個 buffer 檔案
"map <F6> :bn<CR>    " 下一個 buffer 檔案

map <F5> <ESC>:tabnew<CR>

map <F4> <ESC>:call OpenFileFromClipboard()<CR>
imap <F4> <ESC>:call OpenFileFromClipboard()<CR>

"" 單鍵 <F7> 控制 syntax on/off。倒斜線是 Vim script 的折行標誌
" 按一次 <F7> 是 on 的話，再按一次則是 off，再按一次又是 on。
" " 原因是有時候顏色太多會妨礙閱讀。
map <F7> :if exists("syntax_on") <BAR>
     \   syntax off <BAR><CR>
     \ else <BAR>
     \   syntax enable <BAR>
     \ endif <CR>
"                     " 按 F8 會在 searching highlight 及非 highlight 間切換
map <F8> :set hls!<BAR>set hls?<CR>
"                     " Toggle on/off paste mode
map <F9> :set paste!<BAr>set paste?<CR>
set pastetoggle=<F9>

map <F10> <ESC>:read !date<CR>    " 插入日期
"map <F11> :%!xxd<CR>       " 呼叫 xxd 做 16 進位顯示
"map <F12> :%!xxd -r<CR>    " 回復正常顯示
map <F11> <ESC>gT
imap <F11> <ESC>gT
map <F12> <ESC>gt
imap <F12> <ESC>gt

map \v <ESC>:!make > /dev/null<CR><CR>

nnoremap ; :

nmap <tab> V>
nmap <s-tab> V<
xmap <tab> >gv
xmap <s-tab> <gv

"set grepprg=global\ -t
"set grepformat=%m%\\s%\\+%l%\\s%f%.%#

" Transparent editing of gpg encrypted files.
" Placed Public Domain by Wouter Hanegraaff <wouter@blub.net>
" (asc support and sh -c"..." added by Osamu Aoki)
augroup aencrypted
    au!

    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.asc set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.asc set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.asc set bin
    autocmd BufReadPre,FileReadPre      *.asc let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.asc '[,']!sh -c "gpg --decrypt 2> /dev/null"
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.asc set nobin
    autocmd BufReadPost,FileReadPost    *.asc let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.asc execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.asc   '[,']!sh -c "gpg --default-recipient-self -ae 2>/dev/null"
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost    *.asc   u
augroup END
augroup bencrypted
    au!

    " First make sure nothing is written to ~/.viminfo while editing
    " an encrypted file.
    autocmd BufReadPre,FileReadPre      *.gpg set viminfo=
    " We don't want a swap file, as it writes unencrypted data to disk
    autocmd BufReadPre,FileReadPre      *.gpg set noswapfile
    " Switch to binary mode to read the encrypted file
    autocmd BufReadPre,FileReadPre      *.gpg set bin
    autocmd BufReadPre,FileReadPre      *.gpg let ch_save = &ch|set ch=2
    autocmd BufReadPost,FileReadPost    *.gpg '[,']!sh -c "gpg --decrypt 2> /dev/null"
    " Switch to normal mode for editing
    autocmd BufReadPost,FileReadPost    *.gpg set nobin
    autocmd BufReadPost,FileReadPost    *.gpg let &ch = ch_save|unlet ch_save
    autocmd BufReadPost,FileReadPost    *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

    " Convert all text to encrypted text before writing
    autocmd BufWritePre,FileWritePre    *.gpg   '[,']!sh -c "gpg --default-recipient-self -e 2>/dev/null"
    " Undo the encryption so we are back in the normal text, directly
    " after the file has been written.
    autocmd BufWritePost,FileWritePost    *.gpg   u
augroup END


"------------------------------------------------------------------------------
" my settings
"------------------------------------------------------------------------------
augroup ShellScript 
	autocmd!
	autocmd BufWritePost,FileWritePost	*.sh !chmod 755 %
	autocmd BufWritePost,FileWritePost	*.pl !chmod a+x %
	autocmd BufWritePost,FileWritePost	*.rb !chmod a+x %
augroup END
"-----------
" linux kernel coding style
"-----------
"set ts=8
"if !exists("autocommands_loaded")
"  let autocommands_loaded = 1
"  augroup C
"      autocmd BufRead *.c set cindent
"  augroup END
"endif

"-----
" gnu c coding style
"-----
"augroup C
"   autocmd BufRead *.c set cinoptions={.5s,:.5s,+.5s,t0,g0,^-2,e-2,n-2,p2s,(0,=.5s formatoptions=croql cindent shiftwidth=4 tabstop=8
"augroup END

let Tlist_Ctags_Cmd="/usr/bin/ctags"

au BufNewFile,BufRead  svn-commit.* setf svn


"let c_syntax_for_h = 1
"let c_C94 = 1
"let c_C99_warn = 0
"let c_cpp_warn = 0
"let c_warn_8bitchars = 0
"let c_warn_multichar = 0
"let c_warn_digraph = 1
"let c_warn_trigraph = 1
"let c_no_octal = 1
"let c_comment_strings = 1
"let c_comment_numbers = 1
"let c_comment_types = 1
"let c_comment_date_time = 1

"source ~/.vim/syntax/debug.vim
"let g:snip_set_textmate_cp = 1
"source ~/.vim/plugin/snippetsEmu.vim
"imap <Right> <Plug>Jumper
map <F10> :Tlist <CR>
if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
				\	if &omnifunc == "" |
				\		setlocal omnifunc=syntaxcomplete#Complete |
				\	endif
endif
if version >= 603
	set helplang=cn
endif
let python_highlight_all = 1
let changelog_username = "Kanru Chen  <koster@debian.org.tw>"
