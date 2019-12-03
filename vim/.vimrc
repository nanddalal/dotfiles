" Pathogen
call pathogen#infect()

" General text formatting
set encoding=utf-8
set wrap
set nolist
set linebreak
set showbreak=↪
set autoindent
set nosmartindent
filetype plugin indent on
set softtabstop=4
set tabstop=4
set shiftwidth=4
set expandtab
set nosmarttab
set backspace=indent,eol,start
set clipboard=unnamed
let delimitMate_expand_cr = 1

function! SetupPython()
  setlocal softtabstop=4
  setlocal tabstop=4
  setlocal shiftwidth=4
endfunction
command! -bar SetupPython call SetupPython()

" UI
set cc=100
set so=999
set number
set ruler
set laststatus=2
set statusline=%{fugitive#statusline()}
set wildmode=list:longest,list:full
set lazyredraw
set ttyfast
set noshowcmd
let g:indentLine_char = '¦'
let g:indentLine_enabled = 0
nnoremap <Leader>t :IndentLinesToggle<CR>

" Visual
set visualbell
set t_vb=
set showmatch
set mat=5
set hlsearch
nnoremap <F1> :set hlsearch!<CR>
set ignorecase
set smartcase
syntax enable
syntax on

" Colors
let g:solarized_contrast="high"
let g:solarized_termcolors="256"
let g:solarized_termtrans="1"
let g:solarized_visibility="high"
let g:Powerline_symbols='fancy'

colorscheme solarized
set background=dark
let &t_Co=256
let g:airline_theme='base16'
let base16colorspace=256

" Configuration
set nobackup
set nowritebackup
set noswapfile
nnoremap ee :e<CR>
nnoremap ff :q<CR>
nnoremap ss :w<CR>
vnoremap < <gv
vnoremap > >gv

" Unbind the cursor keys in insert, normal and visual modes.
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" Faster window switching
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>

" NERDTree
nmap <Leader>] :NERDTreeToggle<CR>
nmap <Leader>[ :TagbarToggle<CR>
autocmd FocusGained * call s:UpdateNERDTree()

" NERDTree utility function
function s:UpdateNERDTree(...)
  let stay = 0

  if(exists("a:1"))
    let stay = a:1
  end

  if exists("t:NERDTreeBufName")
    let nr = bufwinnr(t:NERDTreeBufName)
    if nr != -1
      exe nr . "wincmd w"
      exe substitute(mapcheck("R"), "<CR>", "", "")
      if !stay
        wincmd p
      end
    endif
  endif

  if exists(":CommandTFlush") == 2
    CommandTFlush
  endif
endfunction

" NERDCommenter remaps
nnoremap mm :call NERDComment(0,"toggle")<CR>
vnoremap mm :call NERDComment(0,"toggle")<CR>

" C-# switches to tab
nmap <Leader>1 1gt
nmap <Leader>2 2gt
nmap <Leader>3 3gt
nmap <Leader>4 4gt
nmap <Leader>5 5gt
nmap <Leader>6 6gt
nmap <Leader>7 7gt
nmap <Leader>8 8gt
nmap <Leader>9 9gt

" Airline options
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#branch#empty_message = ''
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1

" The Silver Searcher

if executable('ag')
  " use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor
endif

" make Ag a shortcut for grep
command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
" automatically open autofix window after grep
autocmd QuickFixCmdPost *grep* cwindow

" bind F to search for all occurences of word under cursor
nnoremap F :Ag <C-r><C-w><CR>
" bind S to search for all occurences of and replace word under cursor
nnoremap S :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>

" IDE functionality

" ale related
nnoremap FF :ALEFix<CR>
nnoremap SS :%!sqlformat --reindent --keywords upper --identifiers lower -<CR>
nnoremap WW :%s/\s\+$//e<CR>
nnoremap LL :ALELint<CR>
let g:ale_fixers = {
\   'python': ['black'],
\   'cpp': ['clang-format'],
\   'proto': ['clang-format'],
\   'html': ['tidy'],
\}
let g:ale_linters = {
\   'python': ['pylint'],
\   'cpp': [],
\   'proto': [],
\}
let g:ale_open_list = 1
let g:ale_python_pylint_change_directory = 0
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0

" fzf related
set rtp+=$DOTFILES_ROOT/vim/.vim/bundle/fzf
nnoremap <C-p> :GitFiles<CR>
nnoremap <C-f> :Files<CR>

" ycm related
nnoremap D :YcmCompleter GetDoc<CR>
nnoremap K :YcmCompleter GoToReferences<CR>
nnoremap T :YcmCompleter GoTo<CR>
let g:ycm_goto_buffer_command = 'vertical-split' " 'new-or-existing-tab'
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.topen = ['<C-t>']

" python debugging
au FileType python map <silent> <Leader>b oimport ipdb; ipdb.set_trace()  # yapf: disable<Esc>

" python and cpp completion
set tag=~/cl_tags
let g:ycm_global_ycm_extra_conf = "~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py"

" latex building
nnoremap MM :make<CR><CR><CR>
