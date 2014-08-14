let s:save_cpo = &cpo
set cpo&vim

let s:path = expand('<sfile>:p:h')

function! unite#kinds#envi#define()
  return s:kind
endfunction

let s:kind = {
      \ 'name' : 'envi',
      \ 'default_action' : 'insert',
      \ 'action_table' : {},
      \}

let s:kind.action_table.new = {
      \ 'description' : 'create new environment variable',
      \ }
function! s:kind.action_table.new.func(candidate)
  if a:candidate.action__belong != "User"
    echo "can not create System environment variable"
    return
  endif
  if a:candidate.action__existence
    echo "this candidate is existence in environment variables"
    return
  endif
  let envi = split(a:candidate.action__envi, '::')
  call s:_set_env(envi[0], envi[1])
endfunction

let s:kind.action_table.edit = {
      \ 'description' : 'edit User environment variable',
      \ }
function! s:kind.action_table.edit.func(candidate)
  if a:candidate.action__belong != "User"
    echo "can not edit System environment variable"
    return
  endif
  let envi = split(a:candidate.action__envi, '::')
  silent! execute 'edit' envi[0]
  call s:_setting_buf(envi[1])
endfunction

function! s:_setting_buf(val)
  call setline(1, a:val)
  augroup PluginWinEnvi
    autocmd!
    autocmd BufWriteCmd <buffer> call s:_write_variable()
  augroup END
  setlocal buftype=acwrite
  setlocal noswapfile
  setlocal nomodified
endfunction

function! s:_write_variable()
  setlocal nomodified
  call s:_set_env(bufname("%"), getline(1))
endfunction

function! s:_set_env(name, val)
  silent! execute '!powershell [Environment]::SetEnvironmentVariable(\"' . a:name . '\", \"' . fnameescape(a:val) . '\", \"User\"^)'
endfunction

let s:kind.action_table.delete = {
      \ 'description' : 'delete from User environment variables',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.delete.func(candidates)
  let arg = ""
  for candidate in a:candidates
    if candidate.action__belong != "User"
      echo "can not delete candidate from System environment variable"
      return
    endif
    let envi = split(candidate.action__envi, '::')
    call s:_set_env(envi[0], "")
  endfor
endfunction

function! unite#kinds#envi#do_action(candidates, action_name)
  if a:action_name == "edit"
    s:kind.action_table.edit.func(a:candidates)
  elseif a:action_name == "delete"
    s:kind.action_table.delete.func(a:candidates)
  else
    echoerr "envi: no action"
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

