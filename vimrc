" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" added by Ivan
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" set line numbers
set number

" set encoding to utf-8
set encoding=utf-8

" this moves cursor when you search, finding words as you write
set incsearch

" ignore case when searching
set ignorecase

" enable changing buffers that are not curretnly displayed
set hidden

" FONT
set gfn=Monospace\ 9

" LINE AND WORD WRAPPING
set wrap " this is default
set linebreak
set nolist " because list disables linebreak

" disable wrapping (<EOL> will be inserted only when enter is pressed)
set textwidth=0 " wraps num cols of text 
set wrapmargin=0 " sets wrap from the right end of window

" color background of characters over 80 columns
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/

" INDENTING

" use spaces instead of <Tab>
set expandtab

" number of spaces for indentation
set shiftwidth=4
set softtabstop=4

" highlighting cursor line and column
set cursorline
set cursorcolumn

" indenting based on file types
filetype plugin indent on

" eclim needed this (but seems useful anyway)
" enables loading plugin files for specific file types
" (it is most probably default ON)
filetype plugin on

" this marks the change range (when 'c' is used in normal mode)
set cpoptions+=$

" enables moving into nonexisting text areas
set virtualedit=all

" folding settings
" (don't really understand them, copied from some video tutorial)
" za (fold/unfold current), zR (unfold all), zM (fold all)
set foldmethod=indent       " fold based on indent
set foldnestmax=10          " deepest fold is 10 levels
set nofoldenable            " don't fold by default
set foldlevel=1

" PATHOGEN PLUGIN (package manager)
call pathogen#infect()

" COLORS
syntax enable

if has("gui_running")
    set background=dark
else
    set background=dark
"    let g:solarized_termtrans=1
    let g:solarized_termcolors=256
endif

let g:solarized_contrast="high"
let g:solarized_visibility="high"

colorscheme solarized

" remove toolbar in gui mode
if has("gui_running")
    set guioptions-=T
endif

" AUTOCOMPLETE SuperTab with vim's OmniComplete
let g:SuperTabDefaultCompletionType = "context"

" VIM TODO: PLUGINS TO SEARCH FOR
" auto code completion (eclim)
" check for configuring OmniComplete
" syntax checking
" code snippets auto insert
" brackets
" (learn) folding
" (learn) macros
" (learn) regex
