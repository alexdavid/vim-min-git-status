command! Gministatus :call g:Gministatus()
function! g:Gministatus()
  silent execute 'pedit ' . GetGitTopLevel() . '/.git/mini-status'
  wincmd P
  silent execute 'lcd ' . GetGitTopLevel()
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap modifiable
  silent execute '$read !git status -b --porcelain'
  map <buffer> <silent> -    :call StageFile()<CR>
  map <buffer> <silent> r    :call Refresh()<CR>
  map <buffer> <silent> R    :call Refresh()<CR>
  map <buffer> <silent> t    :call OpenFile('tabnew')<CR>
  map <buffer> <silent> s    :call OpenFile('split')<CR>
  map <buffer> <silent> v    :call OpenFile('vsplit')<CR>
  map <buffer> <silent> o    :call OpenFile('')<CR>
  map <buffer> <silent> <CR> :call OpenFile('')<CR>
  map <buffer>          .    : <C-R>=GetFilePath()<CR><Home>
  execute 'resize ' . line('$')
  normal ggdd
  execute '%sort /\(^[^#]. \)\@<=.*/ r'
  setlocal nomodifiable
  call Syntax()
endfunction



function! GetGitTopLevel()
  return substitute(system('git rev-parse --show-toplevel'), '\n', '', '')
endfunction



function! Refresh()
  let line_nr=line('.')
  call g:Gministatus()
  execute 'normal '. line_nr . 'G03l'
endfunction



function! GetFilePath()
  return split(getline('.'))[1]
endfunction



function! GetFile2Path()
  return split(getline('.'))[3]
endfunction



function! OpenFile(cmd)
  let file_path = GetFilePath()
  wincmd w
  execute a:cmd
  execute 'edit ' . GetGitTopLevel() . '/' . file_path
endfunction



function! RunGitCommand(cmd)
  call system('git -C ' . GetGitTopLevel() . ' ' . a:cmd)
endfunction



function! StageFile()
  let line = getline('.')
  let file_path = GetFilePath()
  if line =~ '^\(??\|[ MAR]M\)'
    call RunGitCommand('add ' . file_path)

  elseif line =~ '^[MADR] '
    call RunGitCommand('reset -- ' . file_path)
    if line =~ '^R '
      call RunGitCommand('reset -- ' . GetFile2Path())
    endif

  elseif line =~ '^[ MAR]D'
    call RunGitCommand('rm ' . file_path)

  else
    echo "Sorry, I don't know how to stage '" . file_path . "'"
    return

  endif

  call Refresh()
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
