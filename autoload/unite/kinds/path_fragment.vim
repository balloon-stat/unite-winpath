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
    echo "can add candidate to PATH only User environment variable"
    return
  endif
  let cmd = s:path . '\modify_path.bat add'
  let arg = substitute(a:candidate.action__path, '\\$', '', '')
  silent! execute '!' cmd '"' . arg . '"'
endfunction

let s:kind.action_table.remove = {
      \ 'description' : 'remove from PATH',
      \ 'is_selectable' : 1,
      \ }
function! s:kind.action_table.remove.func(candidates)
  if a:candidate.action__belong != "User"
    echo "can remove candidate from PATH only User environment variable"
    return
  endif
  let cmd = s:path . '\modify_path.bat remove'
  let arg = ""
  for candidate in a:candidates
    let arg .= candidate.action__path . "^;"
  endfor
  silent! execute '!' cmd '"' . arg . '"'
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
