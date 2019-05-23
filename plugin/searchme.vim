" @Author: voldikss
" @Date: 2018-08-22 17:50:56
" @Last Modified by: voldikss
" @Last Modified time: 2019-01-26 14:53:09

if exists('g:did_load_vimsearchme') | finish | endif


if get(g:, 'vsm_default_mappings', 1)
    if !hasmapto('<Plug>SearchNormal')
        nmap <silent> <Leader>s <Plug>SearchNormal
    endif

    if !hasmapto('<Plug>SearchVisual')
        vmap <silent> <Leader>s <Plug>SearchVisual
    endif

    if !hasmapto('<Plug>SearchComand')
        nmap <silent> <Leader>S <Plug>SearchComand
    endif
endif


nmap <silent> <Plug>SearchNormal :set operatorfunc=searchme#Start<cr>g@
vmap <silent> <Plug>SearchVisual :<c-u>call searchme#Start(visualmode())<cr>
nmap <silent> <Plug>SearchComand :<c-u>Search<space>


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

let g:did_load_vimsearchme = 1
