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

val tests = [
  Describe "my fact function" [
    It "calculates fact of 0" (fn () => Assert.equal(fact 0, 1)),
    It "calculates fact of 3" (fn () => Assert.equal(fact 3, 6)),
    It "calculates fact of 4" (fn () => Assert.equal(fact 4, 2314234))
  ]
]

val _ = SmellSpec.runTests tests
```

Run your file containing the tests and you'll see something like

```
..F

FAIL: my fact function, calculates fact of 4
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

- `Assert.raises (fn, exn)` - Passes if calling `fn` raises `exn`.
