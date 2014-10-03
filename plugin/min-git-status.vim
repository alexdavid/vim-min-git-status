command! Gministatus :call g:Gministatus()
function! g:Gministatus()
  top new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  silent execute '$read !git status -b --porcelain'
  map <buffer> <silent> -    :call GministatusStageFile()<CR>
  map <buffer> <silent> r    :call GministatusRefresh()<CR>
  map <buffer> <silent> R    :call GministatusRefresh()<CR>
  map <buffer> <silent> t    :call GministatusOpenFile('tabnew')<CR>
  map <buffer> <silent> s    :call GministatusOpenFile('split')<CR>
  map <buffer> <silent> v    :call GministatusOpenFile('vsplit')<CR>
  map <buffer> <silent> o    :call GministatusOpenFile('')<CR>
  map <buffer> <silent> <CR> :call GministatusOpenFile('')<CR>
  execute 'resize ' . line('$')
  normal ggdd
  " silent file .git/index
  execute '%sort /\(^[^#]. \)\@<=.*/ r'
  setlocal nomodifiable
  call Syntax()
endfunction



function! GministatusRefresh()
  let line_nr=line('.')
  quit
  call g:Gministatus()
  execute 'normal '. line_nr . 'G03l'
endfunction



function! GministatusOpenFile(cmd)
  let line=getline('.')
  let file_path=split(line)[1]
  wincmd w
  execute a:cmd
  execute 'edit '. file_path
endfunction



function! GministatusStageFile()
  let line=getline('.')
  let file_path=split(line)[1]
  if line =~ '^\(??\|[ MA]M\)'
    execute 'silent !git add ' . file_path | redraw!
  elseif line =~ '^[MAD] '
    execute 'silent !git reset -- ' . file_path | redraw!
  elseif line =~ '^[ MA]D'
    execute 'silent !git rm ' . file_path | redraw!
  else
    echo "Sorry, I don't know how to stage '" . file_path . "'"
    return
  endif
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
