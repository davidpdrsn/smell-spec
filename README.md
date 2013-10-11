smell-spec
==========

smell-spec is a small testing framework for SML inspired by [rspec](https://github.com/dchelimsky/rspec).

Example
-------

Write some sml

```sml
fun fact 0 = 1
  | fact n = n * fact(n-1);
```

Write some tests

```sml
use "that_other_file_you_wrote";

describe("fact", [
  it_("finds the factorial of 5", fact(5) is_int 120),
  it_("finds the factorial of 0", fact(0) is_int 1),
  it_("finds the factorial of n", fact(10) is_int 20)
]);

runTests();
```

Run your file containing the tests.

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

**Strings:**
- `n is_str m` - Passes if n and m are equal.

**Booleans:**
- `n is_bool m` - Passes if n and m are the same boolean.

**Exceptions:**
- `(f, args) should_raise exn` - Passes if function fn called with args raises exn.
