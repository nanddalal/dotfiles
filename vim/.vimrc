" Pathogen
let g:polyglot_disabled = ['yaml']
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
set signcolumn=number
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
nnoremap mm :call nerdcommenter#Comment(0,"toggle")<CR>
vnoremap mm :call nerdcommenter#Comment(0,"toggle")<CR>

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

" quickfix related
let g:qfenter_keymap = {}
let g:qfenter_keymap.vopen = ['<C-v>']
let g:qfenter_keymap.topen = ['<C-t>']

" coc related
let g:coc_global_extensions = ['coc-pyright']

" python debugging
au FileType python map <silent> <Leader>b oimport ipdb; ipdb.set_trace()  # yapf: disable<Esc>

" latex building
nnoremap MM :make<CR><CR><CR>

" https://github.com/SamSaffron/dotfiles/blob/7ab91a99682e78be8f376ee92329faf16b8177b3/vim/vimrc#L393-L419

" map <leader>g in visual mode to provide a stable link to GitHub source
" allows us to easily select some text in vim and talk about it
function! s:GithubLink(line1, line2)
  let path = resolve(expand('%:p'))
  let dir = shellescape(fnamemodify(path, ':h'))
  let repoN = system("cd " . dir .  " && git remote -v | awk '{ tmp = match($2, /github/); if (tmp) { split($2,a,/github.com[:\.]/); c = a[2]; split(c,b,/[.]/); print b[1]; exit; }}'")

  let repo = substitute(repoN, '\r\?\n\+$', '', '')
  let root = system("cd " . dir . "  && git rev-parse --show-toplevel")
  let relative = strpart(path, strlen(root) - 1, strlen(path) - strlen(root) + 1)


  let repoShaN = system("cd " . dir . " && git rev-parse HEAD")
  let repoSha = substitute(repoShaN, '\r\?\n\+$', '', '')

  let link = "https://github.com/". repo . "/blob/" . repoSha . relative . "#L". a:line1 . "-L" . a:line2

  let @+ = link
  let @* = link

  echo link
endfunction

command! -bar -bang -range -nargs=* GithubLink
  \ keepjumps call <sid>GithubLink(<line1>, <line2>)

vmap <leader>g :GithubLink<cr>

" START coc.nvim section copied and modified from their readme
" https://github.com/neoclide/coc.nvim/blob/master/README.md#example-vim-configuration

" TextEdit might fail if hidden is not set.
set hidden

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-n> and <C-m> for scroll float windows/popups.
"if has('nvim-0.4.0') || has('patch-8.2.0750')
"  nnoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-n>"
"  nnoremap <silent><nowait><expr> <C-m> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-m>"
"  inoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
"  inoremap <silent><nowait><expr> <C-m> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
"  vnoremap <silent><nowait><expr> <C-n> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-n>"
"  vnoremap <silent><nowait><expr> <C-m> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-m>"
"endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

" END coc.nvim section copied and modified from their readme
