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
use "./file_containing_fact_function.sml";

val tests = [
  Describe "my fact function" [
    When "given 0 as argument" [
      It "calculates fact of 0" (fn () => Assert.equal(fact 0, 1))
    ],
    It "calculates fact of 3" (fn () => Assert.equal(fact 3, 6)),
    It "calculates fact of 4" (fn () => Assert.equal(fact 4, 2314234))
  ]
]

val _ = SmellSpec.runTests tests
```

You can use `Describe`, `When` and `It` blocks to spec out your functions. `Describe` and `When` can be nested within each other, as long as there is an `It` at the end.

Run your file containing the tests and you'll see something like

```
Test results

..F

FAIL: my fact function calculates fact of 4
expectation failed

3 tests ran in 0 milliseconds
```

In top-level.

Matchers
--------

*Note:* Using the assertions for specific types will give you better failure messages.

**For all types:**

- `Assert.equal (n, m)` - Passes if n and m are equal (on all types).
- `AssertNot.equal (n, m)` - Passes if n and m are not equal (on all types).

**Ints:**

- `AssertInt.equal (n, m)` - Passes if n and m are two equal ints.
- `AssertInt.greaterThan (n, m)` - Passes if n is greater than m.
- `AssertInt.lessThan (n, m)` - Passes if n is less than m.

**String:**

- `AssertString.equal (n, m)` - Passes if n and m are equal.

**String list:**

- `AssertStringList.equal (n, m)` - Passes if n and m are equal.

**Int list:**

- `AssertIntList.equal (n, m)` - Passes if n and m are equal.

**Exceptions:**

- `Assert.raises (fn, exn)` - Passes if calling `fn()` raises `exn`.
