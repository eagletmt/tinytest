let s:test = {}

function! tinytest#new()
  return deepcopy(s:test)
endfunction

function! s:test.run(...)
  if a:0 == 0
    let l:config = get(g:, 'tinytest_default_config', {})
  else
    let l:config = a:000[0]
  endif
  if !has_key(l:config, 'reporter')
    let l:config.reporter = 'default'
  endif
  if !has_key(l:config, 'asserter')
    let l:config.asserter = 'default'
  endif

  if type(l:config.reporter) == type({})
    let l:reporter = l:config.reporter
  else
    let l:reporter = tinytest#reporter#{l:config.reporter}#new()
  endif
  if type(l:config.asserter) == type({})
    let self.assert = l:config.asserter
  else
    let self.assert = tinytest#asserter#{l:config.asserter}#new()
  endif

  call l:reporter.on_start()

  for l:key in keys(self)
    if l:key =~# '^test_'
      call l:reporter.on_case_start(l:key)
      try
        if has_key(self, 'setup')
          call self.setup()
        endif

        call self[l:key]()
        call l:reporter.on_case_success(l:key)
      catch /^tinytest:/
        let l:msg = substitute(v:exception, '^tinytest:', '', '')
        call l:reporter.on_case_failure(l:key, l:msg, v:throwpoint)
      catch
        call l:reporter.on_case_exception(l:key, v:exception, v:throwpoint)
      endtry

      if has_key(self, 'teardown')
        try
          call self.teardown()
        endtry
      endif
    endif
  endfor

  return l:reporter.on_finish()
endfunction
