let mapleader = ","

" vim上に縦ラインを引く
set colorcolumn=80
highlight ColorColumn guibg=#202020 ctermbg=lightgray

" fzf
" nnoremap <leader>f :<C-u>Files<CR>
" nnoremap <leader>F :<C-u>GFiles<CR>
" nnoremap <leader>b :<C-u>Buffers<CR>
" nnoremap <leader>G :<C-u>Ag<CR>
" nnoremap <leader>g :<C-u>Rg<CR>

" 文字列検索の際にファイル名はmatchしない
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
command! FZFFileList call fzf#run({
  \ 'source': 'find . -type d -name .git -prune -o ! -name .DS_Store',
  \ 'sink': 'e'})

" サイドバー
let NERDTreeShowHidden = 1
:noremap <C-n> :NERDTreeToggle<CR>

" vim-fugitive キーマップ
nnoremap <leader>d :<C-u>Gdiff<CR>
nnoremap <leader>r :<C-u>Git blame<CR>

" vim-gitgutter
"変更点表示の時間を設定
set updatetime=250

let g:gitgutter_override_sign_column_highlight = 0

" インサートモードのカーソル表示変更
let &t_SI.= "\e[6 q"

" 行番号を表示
set number
set relativenumber
set foldcolumn=0
set signcolumn=number

" ステータスライン
let g:lightline = {
	\ 'active': {
	\	'left': [
    \       [ 'mode', 'paste' ],
	\		[ 'gitbranch', 'readonly', 'filename', 'modified' ],
	\	],
	\ },
	\ 'component_function': {
	\	'gitbranch': 'gitbranch#name',
	\	'filename': 'LightlineFilename',
	\ },
	\}

function! LightlineFilename()
	return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
		\ &filetype ==# 'unite' ? unite#get_status_string() :
		\ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
		\ expand('%:t') !=# '' ? expand('%') : '[No Name]'
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0

set laststatus=2
set noshowmode

" 日本語エンコード対応
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,cp932,euc-jp

" タイトルを表示
set title

" シンタックスハイライト
" "syntax on
syntax enable
" Use new regular expression engine
" typescriptのシンタックスエラーを有効にする為の設定
set re=0

" 括弧をハイライト
set showmatch

" インデント幅を4にする
set expandtab
set tabstop=2
set shiftwidth=2

" インサートモードでesc
:imap <silent> jj <ESC>

" セーブのショートカット
nnoremap <C-s> :w<CR>
inoremap <C-s> <C-o>:w<CR>
nnoremap <C-q> :q<CR>

" tab切り替えのショートカット
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" カラースキーム"
" Important!!
if has('termguicolors')
  set termguicolors
endif

set background=dark

" Set contrast.
" This configuration option should be placed before `colorscheme gruvbox-material`.
" Available values: 'hard', 'medium'(default), 'soft'
let g:gruvbox_material_background = 'hard'

colorscheme gruvbox-material

let g:ctrlp_match_func = { 'match' : 'ctrlp_matchfuzzy#matcher' }

nnoremap <leader>ll :call CocAction('format')<CR>

 " GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Defx
" nnoremap <silent> <leader>e :<C-u> Defx <CR>
nnoremap <silent> <leader>e :<C-u> e. <CR>

" netrw
" プレビューウィンドウを垂直分割で表示する
let g:netrw_preview=1

" 表示形式をTreeViewに変更
let g:netrw_liststyle = 3

" vim-oscyank
" vnoremap <leader>c :OSCYank<CR>
" nmap <leader>o <Plug>OSCYank
" let g:oscyank_term = 'tmux'
" let g:oscyank_silent = v:true

