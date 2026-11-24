command! Gministatus :call s:gministatus()
function! s:gministatus()
  silent execute 'pedit ' . fnameescape(s:get_git_top_level() . '/.git/mini-status')
  wincmd P
  silent execute 'lcd ' . fnameescape(s:get_git_top_level())
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap modifiable
  normal! ggdG
  silent execute '$read !git status -b --porcelain'
  call s:set_height()
  normal! ggdd
  execute '%sort /\(^[^#]. \)\@<=.*/ r'
  setlocal nomodifiable
  call s:set_syntax()
  call s:map_keys()
endfunction


function! s:set_height()
  if line('$') / &lines > 0.5
    execute 'resize ' . (&lines / 2)
  else
    execute 'resize ' . line('$')
  endif
endfunction


function! s:get_git_top_level()
  return substitute(system('git rev-parse --show-toplevel'), '\n', '', '')
endfunction


function! s:refresh()
  let line_number = line('.')
  call s:gministatus()
  execute 'normal! '. line_number . 'G03l'
endfunction


function! s:get_file_path()
  if s:current_line_is_comment()
    return ''
  endif
  let line = getline('.')[3:]
  if s:current_line_has_staged_rename()
    return s:unescape_file_name(split(line, ' -> ')[0])
  endif
  return s:unescape_file_name(line)
endfunction


function! s:get_file2_path()
  return s:unescape_file_name(split(getline('.'), ' -> ')[1])
endfunction

function! s:unescape_file_name(n)
  if a:n[0] == '"'
    return a:n[1:-2]
  endif
  return a:n
endfunction

function! s:open_file(cmd)
  let file_path = s:current_line_has_staged_rename() ? s:get_file2_path() : s:get_file_path()
  wincmd w

  " Close an existing diff if open
  windo if &diff | quit | endif

  execute a:cmd
  execute 'edit ' . fnameescape(s:get_git_top_level() . '/' . file_path)
endfunction


function! s:run_git_command(args)
  call system(join(mapnew(['git', '-C', s:get_git_top_level()] + a:args, {_, v -> shellescape(v)})))
endfunction


function! s:run_git_command_in_terminal(args)
  execute '!' . join(mapnew(['git', '-C', s:get_git_top_level()] + a:args, {_, v -> shellescape(v, 1)}))
endfunction


function! s:stage_file()
  let file_path = s:current_line_has_staged_rename() ? s:get_file2_path() : s:get_file_path()

  if s:current_line_has_unstaged_changes() || s:current_line_is_untracked()
    call s:run_git_command(['add', '--', file_path])

  elseif s:current_line_has_staged_changes()
    call s:run_git_command(['reset', '--', file_path])
    if s:current_line_has_staged_rename()
      call s:run_git_command(['reset', '--', s:get_file_path()])
    endif

  elseif s:current_line_has_unstaged_delete()
    call s:run_git_command(['rm', '--', file_path])

  elseif s:current_line_has_unmerged_modifications()
    call s:run_git_command(['add', '--', file_path])

  else
    echo "Sorry, I don't know how to stage " . shellescape(file_path)
    return
  endif
  call s:refresh()
endfunction


function! s:patch_file()
  let file_path = s:get_file_path()

  if s:current_line_has_unstaged_changes()
    call s:run_git_command_in_terminal(['add', '--patch', '--', file_path])

  elseif s:current_line_is_untracked()
    call s:run_git_command(['add', '-N', '--', file_path])
    call s:run_git_command_in_terminal(['add', '--patch', '--', file_path])

  elseif s:current_line_has_staged_changes()
    call s:run_git_command_in_terminal(['reset', '--patch', '--', file_path])

  else
    echo "Sorry, I don't know how to patch " . shellescape(file_path)
  endif
endfunction


function! s:current_line_is_untracked()
  return getline('.') =~ '^??'
endfunction


function! s:current_line_has_unstaged_changes()
  return getline('.') =~ '^\([ MAR]M\| A\)'
endfunction


function! s:current_line_has_unstaged_delete()
  return getline('.') =~ '^[ MAR]D'
endfunction


function! s:current_line_has_staged_changes()
  return getline('.') =~ '^[MADR] '
endfunction


function! s:current_line_has_staged_rename()
  return getline('.') =~ '^R'
endfunction


function! s:current_line_has_unmerged_modifications()
  return getline('.') =~ '^\(AA\|[UD]U\|UD\)'
endfunction


function! s:current_line_is_comment()
  return getline('.') =~ '^#'
endfunction


function! s:set_syntax()
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


function! s:map_keys()
  map <buffer> <silent> -    :call <SID>stage_file()<CR>
  map <buffer> <silent> r    :call <SID>refresh()<CR>
  map <buffer> <silent> R    :call <SID>refresh()<CR>
  map <buffer> <silent> t    :call <SID>open_file('tabnew')<CR>
  map <buffer> <silent> s    :call <SID>open_file('split')<CR>
  map <buffer> <silent> v    :call <SID>open_file('vsplit')<CR>
  map <buffer> <silent> o    :call <SID>open_file('')<CR>
  map <buffer> <silent> p    :call <SID>patch_file()<CR>
  map <buffer> <silent> q    :q<CR>
  map <buffer> <silent> cc   :Git commit<CR>
  map <buffer>          git  : <C-R>=shellescape(<SID>get_file_path(), 1)<CR><Home>!git<space>
  map <buffer> <silent> <CR> :call <SID>open_file('')<CR>
  map <buffer>          .    : <C-R>=fnameescape(<SID>get_file_path())<CR><Home>
endfunction
