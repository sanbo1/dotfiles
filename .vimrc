"
" VIM 設定ファイル
"

"行番号を表示
set number

"ウインドウタイトルを設定
set title

"シンタックス有効(ファイルタイプに応じた色付け)
syntax on

"TAB,EOFなどを可視化する
"set list
"set listchars=tab:>-,extends:<,trail:-,eol:<

"改行時に前の行のインデントを継続する
set autoindent

"改行時に入力された行の末尾に合わせて次の行のインデントを増減する
set smartindent

"検索結果をハイライトする
set hlsearch

"カーソルラインを表示する
"set cursorline

"Tabをスペース4つに展開＆Tabの設定
set tabstop=4
set expandtab
set shiftwidth=4



"
"ステータスライン関連
"
"ステータスラインを下から２行目に表示
set laststatus=2

"ファイル番号表示
set statusline=[%n]

"ファイル名表示
set statusline+=%<%F

"現在文字列/全体列表示
set statusline+=[C=%c/%{col('$')-1}]

"現在文字行/全体行表示
set statusline+=[L=%l/%L]

"現在行が全体行の何%目か表示
set statusline+=[%p%%]


"カーソル位置の記憶
if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif


"---------------------------
" Start Neobundle Settings.
"---------------------------
if isdirectory(expand("~/.vim/bundle/neobundle.vim/"))

    " bundleで管理するディレクトリを指定
    set runtimepath+=~/.vim/bundle/neobundle.vim/

    " Required:
    call neobundle#begin(expand('~/.vim/bundle/'))

    " neobundle自体をneobundleで管理
    NeoBundleFetch 'Shougo/neobundle.vim'

    " ここに追加のプラグインを追記"
    "-----
    " NERDTreeを設定
    "-----
    NeoBundle 'scrooloose/nerdtree'
    " NERDTree 関連設定
    " ファイル指定で開かれた場合はNERDTreeは表示しない
    if !argc()
        autocmd vimenter * NERDTree|normal gg3j
    endif


    "-----
    " 行末の半角スペースを可視化
    "-----
    NeoBundle 'bronson/vim-trailing-whitespace'


    "-----
    " vim用統合ユーザインターフェース
    "-----
    NeoBundle 'Shougo/unite.vim'


    call neobundle#end()

    " Required:
    filetype plugin indent on

    " 未インストールのプラグインがある場合、インストールするかを尋ねる設定
    " 毎回聞かれると邪魔な場合もあるので、この設定は任意
    NeoBundleCheck

endif
"-------------------------
" End Neobundle Settings.
"-------------------------


