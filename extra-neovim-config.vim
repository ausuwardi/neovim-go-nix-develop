" Insert your own config here...

filetype indent plugin on
syntax enable

packloadall

" Fix syntax highlighting in tmux:
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set t_Co=256

set termguicolors

set background=dark
let g:gruvbox_material_background = 'hard'
" let g:gruvbox_material_better_performance = 1
" colorscheme gruvbox-material
colorscheme bat
