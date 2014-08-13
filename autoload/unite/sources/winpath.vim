
let s:save_cpo = &cpo
set cpo&vim

let s:path = expand('<sfile>:p:h')

function! unite#sources#winpath#define()
  return [s:source_winpath, s:source_winpath_add, s:source_winpath_remove]
endfunction

let s:source_winpath = {
        \ 'name' : 'winpath',
        \ 'description' : 'candidates from PATH environment variable',
        \ 'default_kind' : 'path_fragment',
        \}

function! s:source_winpath.gather_candidates(args, context)
  return s:_gather_candidates(a:args, a:context)
endfunction

let s:source_winpath_add = {
        \ 'name' : 'winpath/add',
        \ 'description' : 'to add path candidates from input',
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
        \}
  return dict
endfunction

let s:source_winpath_remove = {
        \ 'name' : 'winpath/remove',
        \ 'description' : 'candidates from PATH environment variable',
        \ 'default_kind' : 'path_fragment',
        \ 'default_action' : 'remove',
        \ }

function! s:source_winpath_remove.gather_candidates(args, context)
  return s:_gather_candidates(a:args, a:context)
endfunction

function! s:_gather_candidates(args, context)
  let cmd = s:path . '\get_path.bat'
  let prc = vimproc#popen2(vimproc#shellescape(cmd))
  let resp = ""
  while !prc.stdout.eof
    let resp .= prc.stdout.read()
  endwhile
  let res = split(substitute(resp, '[[:cntrl:]]', '', 'g'), ',')
  let sys  = s:_create_candidate(res[0], "System")
  let user = s:_create_candidate(res[1], "User")
  return extend(user, sys)
endfunction

function! s:_create_candidate(path, belong)
  if a:belong == "System"
    let prefix = "[System]  "
  elseif a:belong == "User"
    let prefix = "[ User ]  "
  else
    echoerr "_create_candidate:belong is wrong"
  endif
  return map(split(a:path, ';'), '{
        \ "word" : v:val,
        \ "abbr" : prefix . v:val,
        \ "source" : "winpath",
        \ "kind" : "path_fragment",
        \ "action__path" : v:val,
        \ "action__dirctory" : v:val,
        \ "action__belong" : a:belong,
        \ }')
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo