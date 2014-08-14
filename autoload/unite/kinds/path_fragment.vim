let s:save_cpo = &cpo
set cpo&vim

let s:path = expand('<sfile>:p:h')

function! unite#kinds#path_fragment#define()
  return s:kind
endfunction

let s:kind = {
      \ 'name' : 'path_fragment',
      \ 'default_action' : 'start',
      \ 'action_table' : {},
      \ 'parents' : ['cdable', 'uri'],
      \}

let s:kind.action_table.add = {
      \ 'description' : 'add to PATH',
      \ }
function! s:kind.action_table.add.func(candidate)
  if a:candidate.action__belong != "User"
    echo "can not add candidate to System PATH"
    return
  endif
  if a:candidate.action__existence
    echo "this candidate is existence in PATH"
    return
  endif
  let cmd = s:path . '\modify_path.bat add'
  let arg = a:candidate.action__path
  silent! execute '!' cmd shellescape(arg)
endfunction

let s:kind.action_table.edit = {
      \ 'description' : 'edit User PATH fragment',
      \ }
function! s:kind.action_table.edit.func(candidate)
  if a:candidate.action__belong != "User"
    echo "can not edit System PATH fragment"
    return
  endif
  edit PATH
  call s:_setting_buf(a:candidate.action__path)
endfunction

function! s:_setting_buf(path)
  call setline(1, a:path)
  augroup PluginWinPath
    autocmd!
    autocmd BufWriteCmd <buffer> call s:_write_variable()
  augroup END
  let b:edit_path = a:path
  setlocal buftype=acwrite
  setlocal noswapfile
  setlocal nomodified
endfunction

function! s:_write_variable()
  setlocal nomodified
  let cmd_del = s:path . '\modify_path.bat delete'
  let arg_del = b:edit_path . ";"
  silent! execute '!' cmd_del shellescape(arg_del)
  let cmd_add = s:path . '\modify_path.bat add'
  let arg_add = getline(1)
  silent! execute '!' cmd_add shellescape(arg_add)
  let b:edit_path = arg_add
endfunction


let s:kind.action_table.delete = {
      \ 'description' : 'delete from PATH',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.delete.func(candidates)
  let cmd = s:path . '\modify_path.bat delete'
  let arg = ""
  for candidate in a:candidates
    if candidate.action__belong != "User"
      echo "can not delete candidate from System PATH"
      return
    endif
    let arg .= candidate.action__path . ";"
  endfor
  silent! execute '!' cmd shellescape(arg)
endfunction

function! unite#kinds#path_fragment#do_action(candidates, action_name)
  if a:action_name == "edit"
    s:kind.action_table.edit.func(a:candidates)
  elseif a:action_name == "delete"
    s:kind.action_table.delete.func(a:candidates)
  else
    echoerr "path_fragment: no action"
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
