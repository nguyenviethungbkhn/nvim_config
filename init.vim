" ------------------------- Start Plug Install ------------------------------
"  {{
call plug#begin('~/.local/share/nvim/plugged')

" Plug 'neovim/nvim-lsp'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Plug 'fisadev/fisa-vim-colorscheme'
Plug 'patstockwell/vim-monokai-tasty'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'preservim/nerdcommenter'
" Autosave files on certain events
Plug '907th/vim-auto-save'
call plug#end()
" }}
" ------------------------- End Plug Install --------------------------------

" ------------------------ Start External plug install settings -------------

" {{ Airline settings
" Set airline theme
let s:candidate_airlinetheme = ['ayu_mirage', 'base16_flat',
    \ 'base16_grayscale', 'lucius', 'hybridline', 'ayu_dark',
    \ 'base16_adwaita', 'biogoo', 'distinguished', 'jellybeans',
    \ 'luna', 'raven', 'term', 'vice', 'zenburn']
let s:idx = 5
let s:theme = s:candidate_airlinetheme[s:idx]

let g:airline_theme=s:theme

" Tabline settings
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail_improved'

" Show buffer number for easier switching between buffer,
" see https://github.com/vim-airline/vim-airline/issues/1149
let g:airline#extensions#tabline#buffer_nr_show = 1

" Buffer number display format
let g:airline#extensions#tabline#buffer_nr_format = '%s. '

" Whether to show function or other tags on status line
let g:airline#extensions#tagbar#enabled = 1

" Skip empty sections if there are nothing to show,
" extracted from https://vi.stackexchange.com/a/9637/15292
let g:airline_skip_empty_sections = 1

" Whether to use powerline symbols, see https://vi.stackexchange.com/q/3359/15292
let g:airline_powerline_fonts = 0

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'

" Only show git hunks which are non-zero
let g:airline#extensions#hunks#non_zero_only = 1

" Speed up airline
let g:airline_highlighting_cache = 1
" End Airline settings }}


" {{ Auto save settings 
" Enable autosave on nvim startup
let g:auto_save = 1

" A list of events to trigger autosave
let g:auto_save_events = ['InsertLeave', 'TextChanged']
" let g:auto_save_events = ['InsertLeave']

" Show autosave status on command line
let g:auto_save_silent = 0
" }} End auto save settings

" ------------------------ End External Plug Install settings --------------------------------
"
"
"  ----------------------- Auto command -------------------------------
" More accurate syntax highlighting? (see `:h syn-sync`)
augroup accurate_syn_highlight
    autocmd!
    autocmd BufEnter * :syntax sync fromstart
augroup END

" Return to last edit position when opening a file
augroup resume_edit_position
    autocmd!
    autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ | execute "normal! g`\"zvzz"
        \ | endif
augroup END

" Display a message when the current file is not in utf-8 format.
" Note that we need to use `unsilent` command here because of this issue:
" https://github.com/vim/vim/issues/4379
augroup non_utf8_file_warn
    autocmd!
    autocmd BufRead * if &fileencoding != 'utf-8'
                \ | unsilent echomsg 'File not in UTF-8 format!' | endif
augroup END

" Automatically reload the file if it is changed outside of Nvim, see
" https://unix.stackexchange.com/a/383044/221410. It seems that `checktime`
" command does not work in command line. We need to check if we are in command
" line before executing this command. See also
" https://vi.stackexchange.com/a/20397/15292.
augroup auto_read
    autocmd!
    autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
                \ if mode() == 'n' && getcmdwintype() == '' | checktime | endif
    autocmd FileChangedShellPost * echohl WarningMsg
                \ | echo "File changed on disk. Buffer reloaded!" | echohl None
augroup END

"  ----------------------- End auto command ---------------------------
"
"
"  ----------------------- Start options settings ----------------------

" Clipboard settings, always use clipboard for all delete, yank, change, put
" operation, see https://stackoverflow.com/q/30691466/6064933
if !empty(provider#clipboard#Executable())
    set clipboard+=unnamedplus
endif

" Ignore certain files and folders when globbing
set wildignore+=*.o,*.obj,*.bin,*.dll,*.exe
set wildignore+=*/.git/*,*/.svn/*,*/__pycache__/*,*/build/**
set wildignore+=*.pyc
set wildignore+=*.DS_Store
set wildignore+=*.aux,*.bbl,*.blg,*.brf,*.fls,*.fdb_latexmk,*.synctex.gz

"  ----------------------- End options settings -------------------------
"  ----------------------- Set mapleader -------------------------------
let mapleader=","
"  ----------------------- End set mapleader ---------------------------

" TextEdit might fail if hidden is not set.
set hidden

" Set show line number
set number relativenumber

" Set auto completion color
highlight Pmenu ctermbg=black ctermfg=white guibg=gray
highlight PmenuSel ctermfg=yellow guibg=gray

" Set highlight current line
set cursorline
highlight CursorLine cterm=NONE ctermbg=black

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

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
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
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
  else
    call CocAction('doHover')
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

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

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

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>
" Show explorer
nnoremap <space>e :CocCommand explorer<CR>
