" See: http://vimdoc.sourceforge.net/htmldoc/options.html for details

set t_Co=256
colorscheme Tomorrow-Night-Bright    " https://github.com/ChrisKempson/Tomorrow-Theme
syntax    	on                       " enable syntax highlighting
set       	nocompatible             " enable nocompatible options
filetype  	plugin indent on         " load indent for filetype
set       	ruler                    " current pos in buffer
set       	number                   " line numbering
" set         relativenumber
set       	numberwidth=6            " 
set       	cul                      " highlight current line
set       	showcmd                  " show input of an incomplete commanda
set       	showmatch                " when bracket is inserted, briefly jump to the matching one
set       	wildmenu                 " autocompletion
set         wildmode=longest:full,full
set       	nostartofline            " prevent cursor to change current column when changing lines
set       	backspace=2              " fix backspace
set       	laststatus=2             " show status line, even when only one window is open
set       	shortmess=at             " shorten messages to a minimum
set         background=dark          " use dark variation
set         title
set         titlestring=%f%(\ [%M]%)          " Show file name at the title

" searching
set       hlsearch           " don't continue to highlight searched terms  
set     	incsearch          	    " show matches while typing a search
set     	ignorecase         	    " case insensitivity in searches
set     	smartcase          	    " override ignorecase option if search pattern contains upper case characters

" indentation
set     	autoindent           	 " auto indenting (copy indent from current line into next)
" set   	textwidth=80             " longer lines will be broken after white space to get this width
set     	formatoptions=c,q,t      " automatic formatting (r: automatically insert comment leader)

" tabs

set       tabstop=2           	  " set shown width of a \t
set     	shiftwidth=2            " width of (auto)indents 
set     	softtabstop=2           " number of columns per tab
set     	expandtab          	    " tabs to spaces

set         nowrap
set list  listchars=tab:\ \ ,trail:·,extends:>

" directories for .swp files
set backupdir=~/.vim/backup
set directory=~/.vim/backup

" highlight lines > 80 chars
highlight MyLineTooLongMarker ctermbg=Darkred guibg=Darkred
call matchadd('MyLineTooLongMarker', '\%81v', 100)

" draw line at column 80
" if exists('+colorcolumn')
"     set colorcolumn=81
"       highlight ColorColumn ctermbg=red
"     else
"       highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"       match OverLength /\%81v.\+/
" endif

" custom functions
function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
            return "\<tab>"
        elseif "backward" == a:direction
            return "\<c-p>"
        else
            return "\<c-n>"
        endif
endfunction

" keybind
" inoremap <tab> <c-r>=InsertTabWrapper ("forward")<cr>
" inoremap <s-tab> <c-r>=InsertTabWrapper ("backward")<cr>

" redraw screen and remove any search highlighting
nnoremap <silent> <C-l> :nohl<CR><C-l>

nmap ,s :source $HOME/.vimrc
nmap ,v :sp $HOME/.vimrc
