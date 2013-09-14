smell-spec
==========

smell-spec is a small testing framework for SML inspired by [rspec](https://github.com/dchelimsky/rspec).

Example
-------

```sml
use "smell-spec";

fun fact 0 = 1
  | fact n = n * fact(n-1);

describe("fact", [
  this("finds the factorial of 5", fact(5) is_int 120),
  this("finds the factorial of 0", fact(0) is_int 1),
  this("finds the factorial of n", fact(10) is_int 20)
]);

runTests();

```
You will then see something like:

```
..F

FAIL: fact finds the factorial of n
expected 20 to equal 3628800
```

In top-level.

Matchers
--------

**For all types:**

- `n is m` - Passes if n and m are equal (on all types).

**For ints:**
- `n is_int m` - Passes if n and m are equal.
- `n is_not_int m` - Passes if n and m are two non-equal.
- `n is_greater_than_int m` - Passes if n is greater than m.
- `n is_not_greater_than_int m` - Passes if n is less than m.
- `n is_less_than_int m` - Passes if n is less than m.
- `n is_not_less_than_int m` - Passes if n is greater than m.

**Exceptions:**
- `(fn, args) should_raise exn` - Passes if function fn called with args raises exn.
