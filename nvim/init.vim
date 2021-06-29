let g:ale_use_global_executables = 1
call plug#begin('~/.config/nvim/plugged')

Plug 'Shougo/denite.nvim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'w0rp/ale'
Plug 'maximbaz/lightline-ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" Plug 'autozimu/LanguageClient-neovim', {
"     \ 'branch': 'next',
"     \ 'do': 'bash install.sh',
"     \ }

" Appearance
Plug 'chrisbra/Colorizer'
" Plug 'skwp/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'icymind/NeoSolarized'
Plug 'itchyny/lightline.vim'
Plug 'jby/tmux.vim'
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-startify'

" Git
Plug 'gregsexton/gitv'
Plug 'mattn/gist-vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'

" Languages
Plug 'sheerun/vim-polyglot'
Plug 'jtratner/vim-flavored-markdown'
Plug 'skwp/vim-html-escape'
Plug 'mxw/vim-jsx'

" Project
Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin'

" Ruby
Plug 'tpope/vim-rails'
Plug 'tpope/vim-rake'
Plug 'tpope/vim-rvm'
Plug 'vim-ruby/vim-ruby'
Plug 'keith/rspec.vim'
Plug 'skwp/vim-iterm-rspec'
Plug 'skwp/vim-spec-finder'
Plug 'ck3g/vim-change-hash-syntax'
Plug 'tpope/vim-bundler'

" Node
Plug 'moll/vim-node'
Plug 'jelera/vim-javascript-syntax'

" Search
Plug 'justinmk/vim-sneak'
Plug 'vim-scripts/IndexedSearch'
Plug 'nelstrom/vim-visual-star-search'
Plug 'skwp/greplace.vim'
Plug 'easymotion/vim-easymotion'

" textobjects
"Plug 'austintaylor/vim-indentobject'
"Plug 'bootleq/vim-textobj-rubysymbol'
"Plug 'coderifous/textobj-word-column.vim'
"Plug 'kana/vim-textobj-datetime'
"Plug 'kana/vim-textobj-entire'
"Plug 'kana/vim-textobj-function'
"Plug 'kana/vim-textobj-user'
"Plug 'lucapette/vim-textobj-underscore'
"Plug 'nathanaelkane/vim-indent-guides'
"Plug 'nelstrom/vim-textobj-rubyblock'
"Plug 'thinca/vim-textobj-function-javascript'
"Plug 'vim-scripts/argtextobj.vim'

" improvements
Plug 'Raimondi/delimitMate'
Plug 'tomtom/tcomment_vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-ragtag'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'

Plug 'tpope/vim-eunuch'
Plug 'leafo/moonscript-vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'wesQ3/vim-windowswap'
Plug 'itspriddle/vim-marked'
Plug 'markcornick/vim-terraform'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-obsession'
Plug 'junegunn/gv.vim'
Plug 'markcornick/vim-bats'
Plug 'zimbatm/haproxy.vim'
Plug 'janko-m/vim-test'
Plug 'tpope/vim-dispatch'
Plug 'jgdavey/tslime.vim', { 'branch': 'main' }
Plug 'stevearc/vim-arduino'

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    if has('nvim')
      !cargo build --release
    else
      !cargo build --release --no-default-features --features json-rpc
    endif
  endif
endfunction
Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }

call plug#end()

" Open the Ag command and place the cursor into the quotes
nmap ,ag :Ag ""<Left>
nmap ,af :AgFile ""<Left>

" These keys are easier to type than the default set
" We exclude semicolon because it's hard to read and
" i and l are too easy to mistake for each other slowing
" down recognition. The home keys and the immediate keys
" accessible by middle fingers are available 
let g:EasyMotion_keys='asdfjkoweriop'
nmap ,<ESC> ,,w
nmap ,<S-ESC> ,,b

" fugitive.git
" ========================================
" For fugitive.git, dp means :diffput. Define dg to mean :diffget
nnoremap <silent> ,dg :diffget<CR>
nnoremap <silent> ,dp :diffput<CR>

" Support for github flavored markdown
" via https://github.com/jtratner/vim-flavored-markdown
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

" gundo
nmap ,u :GundoToggle<CR>

" open on the right so as not to compete with the nerdtree
let g:gundo_right = 1 

" a little wider for wider screens
let g:gundo_width = 60

" lightline
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'component_function': {
      \   'fugitive': 'MyFugitive',
      \   'readonly': 'MyReadonly',
      \   'filename': 'MyFilename',
      \   'cocstatus': 'coc#status',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

let g:lightline.component_expand = {
      \  'linter_checking': 'lightline#ale#checking',
      \  'linter_warnings': 'lightline#ale#warnings',
      \  'linter_errors': 'lightline#ale#errors',
      \  'linter_ok': 'lightline#ale#ok',
      \ }

let g:lightline.component_type = {
      \     'linter_checking': 'left',
      \     'linter_warnings': 'warning',
      \     'linter_errors': 'error',
      \     'linter_ok': 'left',
      \ }

let g:lightline#ale#indicator_checking = "\uf110"
let g:lightline#ale#indicator_warnings = "\uf071 "
let g:lightline#ale#indicator_errors = "\uf05e "
let g:lightline#ale#indicator_ok = "\uf00c"

let g:lightline.active = {
      \ 'left': [ [ 'mode', 'paste' ],
      \           [ 'fugitive', 'cocstatus', 'readonly', 'filename', 'modified' ] ],
      \ 'right': [[ 'linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok' ], ['lineinfo'], ['percent'], ['fileformat', 'fileencoding', 'filetype']] }

function! MyReadonly()
  if &filetype == "help"
    return ""
  elseif &readonly
    return " "
  else
    return ""
  endif
endfunction

function! MyFugitive()
  if exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? ''._ : ''
  endif
  return ''
endfunction

function! MyFilename()
  return ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
       \ ('' != expand('%') ? expand('%') : '[NoName]')
endfunction

" Use status bar even with single buffer
set laststatus=2

" nerdtree
" Make nerdtree look nice
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let g:NERDTreeWinSize = 30
let g:NERDTreeGitStatusConcealBrackets = 1
let g:NERDTreeGitStatusUseNerdFonts = 1

" path
" Set the shell to bash so we inherit its path, to make sure
" we inherit its path. This affects :Rtags finding the right
" path to homebrewed ctags rather than the XCode version of ctags
set shell=bash

" tComment
" ========================================
" extensions for tComment plugin. Normally
" tComment maps 'gcc' to comment current line
" this adds 'gcp' comment current paragraph (block)
" using tComment's built in <c-_>p mapping
nmap <silent> gcp <c-_>p

" multiple cursors
" Turn off default key mappings
let g:multi_cursor_use_default_mapping=0

" Switch to multicursor mode with ,mc
let g:multi_cursor_start_key=',mc'

" Ctrl-n, Ctrl-p, Ctrl-x, and <Esc> are mapped in the special multicursor
" mode once you've added at least one virtual cursor to the buffer
let g:multi_cursor_next_key='<C-n>'
let g:multi_cursor_prev_key='<C-p>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" Prevent vim-session from asking us to load the session.
" If you want to load the session, use :SaveSession and :OpenSession
let g:session_autosave = 'no'
let g:session_autoload = 'no'

" tmux-navigator
" Don't allow any default key-mappings.
let g:tmux_navigator_no_mappings = 1

" Re-enable tmux_navigator.vim default bindings, minus <c-\>.
" <c-\> conflicts with NERDTree "current file".

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>

" appearance
syntax enable
set background=dark
"colorscheme solarized8
colorscheme NeoSolarized
set termguicolors
let g:neosolarized_visibility = "normal"

" keymaps
" Make 0 go to the first character rather than the beginning
" of the line. When we're programming, we're almost always
" interested in working with text rather than empty space. If
" you want the traditional beginning of line, use ^
nnoremap 0 ^
nnoremap ^ 0

" ,# Surround a word with #{ruby interpolation}
map ,# ysiw#
vmap ,# c#{<C-R>"}<ESC>

" ," Surround a word with "quotes"
map ," ysiw"
vmap ," c"<C-R>""<ESC>

" ,' Surround a word with 'single quotes'
map ,' ysiw'
vmap ,' c'<C-R>"'<ESC>

" ,) or ,( Surround a word with (parens)
" The difference is in whether a space is put in
map ,( ysiw(
map ,) ysiw)
vmap ,( c( <C-R>" )<ESC>
vmap ,) c(<C-R>")<ESC>

" ,[ Surround a word with [brackets]
map ,] ysiw]
map ,[ ysiw[
vmap ,[ c[ <C-R>" ]<ESC>
vmap ,] c[<C-R>"]<ESC>

" ,{ Surround a word with {braces}
map ,} ysiw}
map ,{ ysiw{
vmap ,} c{ <C-R>" }<ESC>
vmap ,{ c{<C-R>"}<ESC>

map ,` ysiw`

" Create window splits easier. The default
" way is Ctrl-w,v and Ctrl-w,s. I remap
" this to vv and ss
nnoremap <silent> vv <C-w>v
nnoremap <silent> ss <C-w>s

"Clear current search highlight by double tapping //
nmap <silent> // :nohlsearch<CR>

" global customizations

set number                      "Line numbers are good
set backspace=indent,eol,start  "Allow backspace in insert mode
set history=1000                "Store lots of :cmdline history
set showcmd                     "Show incomplete cmds down the bottom
set showmode                    "Show current mode down the bottom
set gcr=a:blinkon0              "Disable cursor blink
set visualbell                  "No sounds
set autoread                    "Reload files changed outside vim

" This makes vim act like all other editors, buffers can
" exist in the background without being in a window.
" http://items.sjbach.com/319/configuring-vim-right
set hidden

"turn on syntax highlighting
syntax on

" Change leader to a comma because the backslash is too far away
" That means all \x commands turn into ,x
" The mapleader has to be set before vundle starts loading all 
" the plugins.
let mapleader=","

" ================ Turn Off Swap Files ==============

set noswapfile
set nobackup
set nowb

" ================ Indentation ======================

set autoindent
set smartindent
set smarttab
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab

filetype plugin on
filetype indent on

" Display tabs and trailing spaces visually
set listchars=tab:▸\ ,eol:¬,trail:·
set list!

set nowrap       "Don't wrap lines
set linebreak    "Wrap lines at convenient points

" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif


" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

set encoding=utf-8

set clipboard+=unnamedplus

set mouse=nir

"fzf
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

nnoremap <silent> ,t :Files<CR>
nnoremap <silent> ,b :Buffers<CR>
nnoremap <silent> ,w :Windows<CR>

" ale
let g:ale_sign_column_always = 1
let g:ale_lint_delay = 500

function! FindProjectRoot(buffer) abort
  let l:git_path = ale#path#FindNearestDirectory(a:buffer, '.git')
  return !empty(l:git_path) ? fnamemodify(l:git_path, ':h:h') : ''
endfunction

" call ale#Set('ruby_lsp_address', '127.0.0.1:7658')
" call ale#linter#Define('ruby', {
" \   'name': 'lsp',
" \   'lsp': 'socket',
" \   'language': 'ruby',
" \   'address_callback': ale#VarFunc('ruby_lsp_address'),
" \   'project_root_callback': 'FindProjectRoot'
" \})
"
" call ale#Set('elixir_lsp_address', '127.0.0.1:7659')
" call ale#linter#Define('elixir', {
" \   'name': 'lsp',
" \   'lsp': 'socket',
" \   'language': 'elixir',
" \   'address_callback': ale#VarFunc('elixir_lsp_address'),
" \   'project_root_callback': 'FindProjectRoot'
" \})
"
" call ale#Set('elm_lsp_address', '127.0.0.1:7660')
" call ale#linter#Define('elm', {
" \   'name': 'lsp',
" \   'lsp': 'socket',
" \   'language': 'elm',
" \   'address_callback': ale#VarFunc('elm_lsp_address'),
" \   'project_root_callback': 'FindProjectRoot'
" \})
"
" call ale#Set('bash_lsp_address', '127.0.0.1:7661')
" call ale#linter#Define('sh', {
" \   'name': 'lsp',
" \   'lsp': 'socket',
" \   'language': 'sh',
" \   'address_callback': ale#VarFunc('bash_lsp_address'),
" \   'project_root_callback': 'FindProjectRoot'
" \})
"
" call ale#Set('dockerfile_lsp_address', '127.0.0.1:7662')
" call ale#linter#Define('dockerfile', {
" \   'name': 'lsp',
" \   'lsp': 'socket',
" \   'language': 'dockerfile',
" \   'address_callback': ale#VarFunc('dockerfile_lsp_address'),
" \   'project_root_callback': 'FindProjectRoot'
" \})

" let g:ale_linters = {
" \ 'ruby': ['lsp'],
" \ 'elixir': ['lsp'],
" \ 'elm': ['lsp'],
" \ 'sh': ['lsp'],
" \ 'dockerfile': ['lsp'],
" \}

let g:ale_linters = {
\ 'ruby': ['brakeman', 'rails_best_practices', 'reek', 'ruby'],
\}

let g:ale_fixers = {
\ 'elixir': ['mix_format']
\}
let g:ale_fix_on_save = 1

" let g:ale_ruby_lsp_address = 'default:7658'
" let g:ale_elixir_lsp_address = 'default:7659'
" let g:ale_elm_lsp_address = 'default:7660'
" let g:ale_bash_lsp_address = 'default:7661'
" let g:ale_dockerfile_lsp_address = 'default:7662'

" language client setup
let g:LanguageClient_autoStart = 1
let g:LanguageClient_autoStop = 1
" let g:LanguageClient_loggingFile = '/tmp/languageclient.log'
" let g:LanguageClient_loggingLevel = 'DEBUG'
" let g:LanguageClient_windowLogMessageLevel = 'Log'
" let g:LanguageClient_serverStderr = '/tmp/languageserver.log'
" let g:LanguageClient_trace = 'verbose'
let g:LanguageClient_waitOutputTimeout = 30
let g:LanguageClient_loadSettings = 0
let g:LanguageClient_serverCommands = {
  \ 'ruby': ['/usr/local/lib/ruby/gems/2.5.0/bin/solargraph', 'stdio'],
  \ 'sh': ['bash-language-server', 'start'],
  \ 'Dockerfile': ['docker-langserver', '--stdio']
  \ }

" vim-test
function! DevTransform(cmd) abort
  "return "dev run --rm $(cat docker-compose.yml | grep 'dev run' | cut -f 4 -d ' ') ".a:cmd
  return "dev run --rm rails ".a:cmd
endfunction

let g:test#custom_transformations = {'dev': function('DevTransform')}
let g:test#transformation = 'dev'
let test#strategy = "tslime"
let g:test#preserve_screen = 1
let test#ruby#rspec#executable = 'rspec'

nmap <silent> <leader>r :TestNearest<CR>
nmap <silent> <leader>R :TestFile<CR>
nmap <silent> <leader>l :TestLast<CR>

" Source: http://stackoverflow.com/a/1470179
"
" Example Output: 
" hi<jsImport> trans<jsImport> lo<Include> FG: #fa9a4bj
map <F3> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">" . " FG:" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"fg#")<CR>

" Reformat visual selection as JSON
vnoremap <Leader>j !jq '.'<CR>

" Coc
" Better display for messages
set cmdheight=2

" Smaller updatetime for CursorHold & CursorHoldI
set updatetime=300

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> for trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <C-x><C-o> to complete 'word', 'emoji' and 'include' sources
imap <silent> <C-x><C-o> <Plug>(coc-complete-custom)

" Use <cr> for confirm completion.
" Coc only does snippet and additional edit on confirm.
let g:endwise_no_mappings = 1
"inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"
" imap <C-X><CR>   <CR><Plug>AlwaysEnd
imap <expr> <CR> (pumvisible() ? "\<C-Y>\<Plug>DiscretionaryEnd" : "\<CR>\<Plug>DiscretionaryEnd")

" Use `[c` and `]c` for navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Show signature help while editing
autocmd CursorHoldI * silent! call CocActionAsync('showSignatureHelp')

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
vmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)


" Add diagnostic info for https://github.com/itchyny/lightline.vim
" let g:lightline = {
"       \ 'colorscheme': 'wombat',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
"       \ },
"       \ 'component_function': {
"       \   'cocstatus': 'coc#status'
"       \ },
"       \ }



" Shortcuts for denite interface
" Show symbols of current buffer
nnoremap <silent> <space>o  :<C-u>Denite coc-symbols<cr>
" Search symbols of current workspace
nnoremap <silent> <space>t  :<C-u>Denite coc-workspace<cr>
" Show diagnostics of current workspace
nnoremap <silent> <space>a  :<C-u>Denite coc-diagnostic<cr>
" Show available commands
nnoremap <silent> <space>c  :<C-u>Denite coc-command<cr>
" Show available services
nnoremap <silent> <space>s  :<C-u>Denite coc-service<cr>
" Show links of current buffer
nnoremap <silent> <space>l  :<C-u>Denite coc-link<cr>

" Shortcuts for NERDTree
nnoremap <leader>nt :NERDTreeToggleVCS<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" git gutter
autocmd BufWritePost,WinEnter * GitGutter

" vim-startify
let g:startify_change_to_vcs_root = 1

so ~/.config/nvim/solarized.vim
