
let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#winpath#define()
  return [s:source_winpath, s:source_winpath_add]
endfunction

let s:source_winpath = {
        \ 'name' : 'winpath',
        \ 'description' : 'candidates from PATH environment variable in Windows',
        \ 'default_kind' : 'path_fragment',
        \}

function! s:source_winpath.gather_candidates(args, context)
  let cmd_sys = "cmd /c \"powershell [Environment]::GetEnvironmentVariable('PATH', 'Machine')\""
  let cmd_usr = "cmd /c \"powershell [Environment]::GetEnvironmentVariable('PATH', 'User')\""
  let sys  = s:_create_candidate(system(cmd_sys), "System")
  let user = s:_create_candidate(system(cmd_usr), "User")
  return extend(user, sys)
endfunction

let s:source_winpath_add = {
        \ 'name' : 'winpath/add',
        \ 'description' : 'to add path candidate from input',
        \ 'default_kind' : 'path_fragment',
        \ 'default_action' : 'add',
        \ }

function! s:source_winpath_add.change_candidates(args, context)
  let input = unite#util#expand(a:context.input)
  if input == ''
    return []
  endif
  return [unite#sources#winpath#create_path_dict(input)]
endfunction

function! unite#sources#winpath#create_path_dict(path)
  let dict = {
        \ 'word' : a:path,
        \ 'abbr' : '[add path] ' . a:path,
        \ 'kind' : 'path_fragment',
        \ 'action__path' : a:path,
        \ "action__dirctory" : a:path,
        \ "action__belong" : 'User',
        \}
  return dict
endfunction

function! s:_create_candidate(path, belong)
  let paths = substitute(substitute(a:path,
        \       '\n', '', ''), ';$', '', '')
  if a:belong == "System"
    let prefix = "[System]  "
  elseif a:belong == "User"
    let prefix = "[ User ]  "
  else
    echoerr "_create_candidate:belong is wrong"
  endif
  return map(split(paths, ';'), '{
        \ "word" : v:val,
        \ "abbr" : prefix . v:val,
        \ "source" : "winpath",
        \ "kind" : "path_fragment",
        \ "action__path" : v:val,
        \ "action__dirctory" : v:val,
        \ "action__belong" : a:belong,
        \ }')
endfunction

function! unite#sources#winpath#edit_path_fragments(srcs)
  call unite#kinds#path_fragment#do_action(a:srcs, 'edit')
endfunction

function! unite#sources#winpath#delete_path_fragments(srcs)
  call unite#kinds#path_fragment#do_action(a:srcs, 'delete')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
