" 行番号を表示
set number
" タイトルを表示
set title
" シンタックスハイライト
syntax on

" tab切り替えのショートカット
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

"vim プラグイン管理ツール
"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('~/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

" Add or remove your plugins here like this:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')

call dein#add('preservim/nerdtree')

call dein#add('jiangmiao/auto-pairs')

" gitのdiffを表示させるもの
call dein#add('airblade/vim-gitgutter')

" 文末のスペースを消してくれる
call dein#add('bronson/vim-trailing-whitespace')

" ファイル検索のプラグイン
call dein#add('ctrlpvim/ctrlp.vim')

" ファイルを補完するもの
call dein#add('neoclide/coc.nvim')

"Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts------------------------

"nerdtree
map <C-e> :NERDTreeToggle<CR>

" vim-gitgutter
"変更点表示の時間を設定
set updatetime=250

let g:gitgutter_override_sign_column_highlight = 0
highlight SignColumn ctermbg=brown

