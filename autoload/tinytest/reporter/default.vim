let s:reporter = {}

function! tinytest#reporter#default#new()
  return deepcopy(s:reporter)
endfunction

function! s:reporter.on_start()
  let self._total = 0
  let self._success = 0
  let self._failure = 0
endfunction

function! s:reporter.on_finish()
  if self._failure != 0
    echohl ErrorMsg
  endif
  echomsg printf('Total %d, Success %d, Failure %d', self._total, self._success, self._failure)
  echohl None
endfunction

function! s:reporter.on_case_start(name)
  let self._total += 1
endfunction

function! s:reporter.on_case_success(name)
  let self._success += 1
endfunction

function! s:reporter.on_case_failure(name, msg, throwpoint)
  let self._failure += 1
  echomsg printf('%s failed at [%s]: %s', a:name, a:throwpoint, a:msg)
endfunction

function! s:reporter.on_case_exception(name, exception, throwpoint)
  let self._failure += 1
  echomsg printf("%s raised at [%s]: %s", a:name, a:throwpoint, a:exception)
endfunction
