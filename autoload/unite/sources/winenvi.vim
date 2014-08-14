
let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#winenvi#define()
  return [s:source_winenvi, s:source_winenvi_new]
endfunction

let s:source_winenvi = {
        \ 'name' : 'winenvi',
        \ 'description' : 'candidates from environment variables in Windows',
        \ 'default_kind' : 'envi',
        \}

function! s:source_winenvi.gather_candidates(args, context)
  let cmd_sys = "cmd /c \"powershell [Environment]::GetEnvironmentVariables('Machine')\""
  let cmd_usr = "cmd /c \"powershell [Environment]::GetEnvironmentVariables('User')\""
  let sys  = s:_create_candidate(system(cmd_sys), "System")
  let user = s:_create_candidate(system(cmd_usr), "User")
  return extend(user, sys)
endfunction

let s:source_winenvi_new = {
        \ 'name' : 'winenvi/new',
        \ 'description' : 'create environment variable candidate from input',
        \ 'default_kind' : 'envi',
        \ 'default_action' : 'new',
        \ }

function! s:source_winenvi_new.change_candidates(args, context)
  let input = unite#util#expand(a:context.input)
  if input == ''
    return []
  endif
  return [unite#sources#winenvi#create_envi_dict(input)]
endfunction

function! unite#sources#winenvi#create_envi_dict(envi)
  let dict = {
        \ 'word' : a:envi,
        \ 'abbr' : '[new env::value] ' . a:envi,
        \ 'kind' : 'envi',
        \ 'action__envi' : a:envi,
        \ "action__belong" : 'User',
        \ "action__existence" : 0,
        \}
  return dict
endfunction

function! s:_create_candidate(envi, belong)
  if a:belong == "System"
    let prefix = "[System]  "
  elseif a:belong == "User"
    let prefix = "[ User ]  "
  else
    echoerr "_create_candidate:belong is wrong"
  endif
  let vars = map(split(a:envi, "\n"), 'substitute(
        \ substitute(v:val, ''\s\+'', ''::'', ''''), ''\s\+'', '''', '''')')
  return map(vars[2:-3], '{
        \ "word" : v:val,
        \ "abbr" : prefix . v:val,
        \ "source" : "winenvi",
        \ "kind" : "envi",
        \ "action__envi" : v:val,
        \ "action__belong" : a:belong,
        \ "action__existence" : 1,
        \ }')
endfunction

function! unite#sources#winenvi#edit_envi(srcs)
  call unite#kinds#envi#do_action(a:srcs, 'edit')
endfunction

function! unite#sources#winenvi#delete_envi(srcs)
  call unite#kinds#envi#do_action(a:srcs, 'delete')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo

