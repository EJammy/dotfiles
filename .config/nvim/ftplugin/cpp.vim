map <F9> :w<CR>:!./a.out<CR>
map <F8> :w<CR>:!clear && g++ -std=c++17 -Wall -Wshadow -fsanitize=undefined -fsanitize=address -D_GLIBCXX_DEBUG -g "%"<CR>
map <Leader>r <F9>1
map <F9>1 :w<CR>:!clear && ./a.out < in<CR>
map <F9>2 :w<CR>:!./a.out < in > out<CR>
map <F10> :w<CR>:!clear && g++ -std=c++17 -Wall -Wshadow -fsanitize=undefined -fsanitize=address -D_GLIBCXX_DEBUG -g "%" && echo "start" && ./a.out<CR>

" c++ fast typing
ab pb push_back
ab NN << '\n'

