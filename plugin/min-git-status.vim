command! Gministatus :call g:Gministatus()
function! g:Gministatus()
  silent pedit .git/ministatus
  wincmd P
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap modifiable
  silent execute '$read !git status -b --porcelain'
  map <buffer> <silent> -    :call GministatusStageFile()<CR>
  map <buffer> <silent> r    :call GministatusRefresh()<CR>
  map <buffer> <silent> R    :call GministatusRefresh()<CR>
  map <buffer> <silent> t    :call GministatusOpenFile('tabnew')<CR>
  map <buffer> <silent> s    :call GministatusOpenFile('split')<CR>
  map <buffer> <silent> v    :call GministatusOpenFile('vsplit')<CR>
  map <buffer> <silent> o    :call GministatusOpenFile('')<CR>
  map <buffer> <silent> <CR> :call GministatusOpenFile('')<CR>
  map <buffer>          .    : <C-R>=GministatusGetFilePath()<CR><Home>
  execute 'resize ' . line('$')
  normal ggdd
  execute '%sort /\(^[^#]. \)\@<=.*/ r'
  setlocal nomodifiable
  call Syntax()
endfunction



function! GministatusRefresh()
  let line_nr=line('.')
  call g:Gministatus()
  execute 'normal '. line_nr . 'G03l'
endfunction



function! GministatusGetFilePath()
  return split(getline('.'))[1]
endfunction



function! GministatusOpenFile(cmd)
  let file_path = GministatusGetFilePath()
  wincmd w
  execute a:cmd
  execute 'edit '. file_path
endfunction



function! GministatusRunGitCommand(cmd)
  execute 'silent !git ' . a:cmd | redraw!
endfunction



function! GministatusStageFile()
  let line = getline('.')
  let file_path = GministatusGetFilePath()
  if line =~ '^\(??\|[ MA]M\)'
    call GministatusRunGitCommand('add ' . file_path)
  elseif line =~ '^[MAD] '
    call GministatusRunGitCommand('reset -- ' . file_path)
  elseif line =~ '^[ MA]D'
    call GministatusRunGitCommand('rm ' . file_path)
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
