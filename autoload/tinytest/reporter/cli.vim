let s:reporter = {}

function! tinytest#reporter#cli#new()
  return deepcopy(s:reporter)
endfunction

let s:stdout_file = 'stdout.log'

function! s:reporter.on_start()
  let self._total = 0
  let self._success = 0
  let self._failure = 0
  if filereadable(s:stdout_file)
    call delete(s:stdout_file)
  endif
endfunction

function! s:reporter.on_finish()
  call s:appendfile([printf('Total %d, Success %d, Failure %d', self._total, self._success, self._failure)])
  if self._failure == 0
    qall!
  else
    cquit!
  endif
endfunction

function! s:reporter.on_case_start(name)
  let self._total += 1
endfunction

function! s:reporter.on_case_success(name)
  let self._success += 1
endfunction

function! s:reporter.on_case_failure(name, msg, throwpoint)
  let self._failure += 1
  call s:appendfile([printf('%s failed at [%s]', a:name, a:throwpoint), a:msg])
endfunction

function! s:reporter.on_case_exception(name, exception, throwpoint)
  let self._failure += 1
  call s:appendfile([printf('%s raised at [%s]', a:name, a:throwpoint), a:exception])
endfunction

function! s:appendfile(lines)
  if filereadable(s:stdout_file)
    let l:lines = readfile(s:stdout_file)
  else
    let l:lines = []
  endif
  call writefile(l:lines + a:lines, s:stdout_file)
endfunction
