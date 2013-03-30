let s:asserter = {}

function! tinytest#asserter#default#new()
  return deepcopy(s:asserter)
endfunction

function! s:asserter.equal(expected, actual)
  if a:expected != a:actual
    throw printf("tinytest:expected %s\n but got %s", string(a:expected), string(a:actual))
  endif
endfunction

function! s:asserter.not_equal(expected, actual)
  if a:expected == a:actual
    throw printf("tinytest:not expected %s\n     but got %s", string(a:expected), string(a:actual))
  endif
endfunction

function! s:asserter.empty(actual)
  if !empty(a:actual)
    throw printf("tinytest:expected to be empty: %s", string(a:actual))
  endif
endfunction

function! s:asserter.not_empty(actual)
  if empty(a:actual)
    throw printf("tinytest:expected not to be empty: %s", string(a:actual))
  endif
endfunction

function! s:asserter.any(pred, actual)
  for l:val in a:actual
    if a:pred.call(l:val)
      return 1
    endif
    unlet l:val
  endfor
  throw printf("tinytest:expected to satisfy any: %s", string(a:actual))
endfunction

function! s:asserter.none(pred, actual)
  for l:val in a:actual
    if a:pred.call(l:val)
      throw printf("tinytest:expected to satisfy none %s", string(a:actual))
    endif
    unlet l:val
  endfor
endfunction

function! s:asserter.exist(sym)
  if !exists(a:sym)
    throw printf("tinytest:expected to exist: %s", a:sym)
  endif
endfunction

function! s:asserter.not_exist(sym)
  if exists(a:sym)
    throw printf("tinytest:expected not to exist: %s", a:sym)
  endif
endfunction

function! s:asserter.match(regexp, actual)
  if a:actual !~# a:regexp
    throw printf("tinytest:expected to match %s\n  actual: %s", a:regexp, string(a:actual))
  endif
endfunction
