command! Gministatus :call g:Gministatus()
function! g:Gministatus()
  top new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  silent execute '$read !git status -b --porcelain'
  map <buffer> <silent> - :call GministatusStageFile()<CR>
  map <buffer> <silent> r :call GministatusRefresh()<CR>
  map <buffer> <silent> R :call GministatusRefresh()<CR>
  execute 'resize ' . line('$')
  normal ggdd
  silent file .git/index
  execute "%sort /\\(^[^#]. \\)\\@<=.*/ r"
  setlocal nomodifiable
  call Syntax()
endfunction



function! GministatusRefresh()
  let line_nr=line('.')
  quit
  call g:Gministatus()
  execute 'normal '. line_nr . 'G03l'
endfunction



function! GministatusStageFile()
  let line=split(getline('.'))
  let staged=line[0]
  let file_path=line[1]
  execute 'silent !git add ' . file_path | redraw!
  call GministatusRefresh()
endfunction



function! Syntax()
  syn match GministatusLocalBranch /\(^## \)\@<=[^.]*/
  syn match GministatusRemoteBranch /\(^##.*\.\.\.\)\@<=.*/
  syn match GministatusStaged /^[MADRCU]/
  syn match GministatusUnstaged /\(^.\)\@<=[MADU]/
  syn match GministatusUntracked /^\(??\|!!\|##\)/

  hi GministatusStaged       ctermfg=2
  hi GministatusUnstaged     ctermfg=1
  hi GministatusUntracked    ctermfg=8
  hi GministatusLocalBranch  ctermfg=2
  hi GministatusRemoteBranch ctermfg=1
endfunction
