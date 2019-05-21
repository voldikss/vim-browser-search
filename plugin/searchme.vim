" @Author: voldikss
" @Date: 2018-08-22 17:50:56
" @Last Modified by: voldikss
" @Last Modified time: 2019-01-26 14:53:09

if exists('g:did_load_searchme') | finish | endif


command! -complete=customlist,searchme#Complete -nargs=?        SearchCurrentText :call searchme#SearchCurrentText(<f-args>)
command! -complete=customlist,searchme#Complete -nargs=? -range SearchVisualText  :call searchme#SearchVisualText(<f-args>)

command! -complete=customlist,searchme#Complete -nargs=+        Search            :call searchme#SearchIn(<q-args>)
command!                                        -nargs=+        SearchInGoogle    :call searchme#SearchIn(<q-args>, 'google')
command!                                        -nargs=+        SearchInMMA       :call searchme#SearchIn(<q-args>, 'mathematica')
command!                                        -nargs=+        SearchInBaidu     :call searchme#SearchIn(<q-args>, 'baidu')
command!                                        -nargs=+        SearchInGithub    :call searchme#SearchIn(<q-args>, 'github')
command!                                        -nargs=+        SearchInSO        :call searchme#SearchIn(<q-args>, 'stackoverflow')
command!                                        -nargs=+        SearchInBilibili  :call searchme#SearchIn(<q-args>, 'bilibili')
command!                                        -nargs=+        SearchInZhihu     :call searchme#SearchIn(<q-args>, 'zhihu')

nnoremap <silent> <leader>s :set operatorfunc=searchme#Start<cr>g@
vnoremap <silent> <leader>s :<c-u>call searchme#Start(visualmode())<cr>
noremap  <silent> <Leader>S :Search<space>

let g:did_load_searchme = 1
