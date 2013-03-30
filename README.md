# tinytest

## Usage

```vim
let s:unit = tinytest#new()

function! s:unit.setup()
  let self.value = 1
endfunction

function! s:unit.teardown()
  unlet self.value
endfunction

function! s:unit.test_plus()
  call self.assert.equal(3, self.value + 2)
  call self.assert.equal([1, 2, 3], [self.value] + [2, 3])
endfunction

call s:unit.run()
```

1. Create a tinytest object by `tinytest#new()`
2. Write test cases as a dictionary function whose name has `test_` prefix
  - Special methods `setup` and `teardown` are supported.
3. Write assertions by asserter object
4. Invoke `run` method and the result is reported by reporter object

## Mechanism

### asserter
Asserter's methods should throw an exception prefixed with `tinytest:` if the assertion fails.

The default asserter is located at `autoload/tinytest/asserter/default.vim`.

### reporter
A reporter object is hold by each test unit internally.
You cannot touch reporter object from test cases and asserters.
A reporter must have these methods:

- `on_start` will called when a test unit starts.
- `on_case_start` will called each time a test case starts.
- `on_case_success` will called each time a test case succeeds, i.e., no exceptions are thrown.
- `on_case_failure` will called each time a test case fails, i.e., an exception prefixed with `tinytest:` is thrown.
- `on_case_exception` will called each time a test case throws other exception.
- `on_finish` will called when a test unit finishes.

Note that only one of `on_case_success`, `on_case_failure` and `on_case_exception` is called for each test case.

The default reporter echoes the result.

`cli` reporter writes the result to `stdout.log` file.
It is supposed to be used when you run tests from command line.

## Design policy

### Don't parse
Test cases should be written as an ordinal Vim script.
Parsing string arguments are evil.

### Easy to change reporting format
- When you execute tests in Vim, `:echo` or `:call setline()` to a special buffer would be suitable (default reporter).
- When you execute tests from command line, reporting to a file and changing exit status according to the result would be useful (cli reporter).

### Tiny
No very useful but complex functionalities.

## License
[MIT license](http://www.opensource.org/licenses/MIT)

Copyright (c) 2013, eagletmt
