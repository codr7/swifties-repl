## Swifties REPL

### intro
This projects aims to demonstrate how to implement a custom Lisp with REPL using [Swifties](https://github.com/codr7/swifties).

```
Swifties v2

Hitting Return evaluates once a form is complete,
(reset) clears the stack and Ctrl+D quits.

  (do 1 2 3)
[1 2 3]

  (do 4 stash 5 6)
[[1 2 3 4] 5 6]

  (do drop drop splat)
[1 2 3 4]
```

### quirks
- The stack is directly exposed to user code, just like in Forth.
- Primitives, Macros and Functions are called on reference with no arguments outside of call forms.
- Parens are used for calls only, brackets for lists of things.
- There's no syntax yet for automagically binding function arguments, think Perl until recently.

### bindings
Values may be bound to identifiers using `let`.

```
  (let [x 35 y 7]
      (+ x y))
[42]
```

### functions
New functions may be defined using `func`.

```
  (func fibrec [Int] [Int]
      (let [n _]
          (if (< n 2) n (+ (fibrec (-1 n)) (fibrec (-2 n))))))
[]

  (fibrec 20)
[6765]
```
The algorithm can definitely be improved, note that I had to change `n` from `10` to `50` to even get something worth measuring.

```
  (func fibtail1 [Int Int Int] [Int]
      (let [n _ a _ b _]
          (if (=0 n) a (if (=1 n) b (fibtail1 (-1 n) b (+ a b))))))
[]

  (bench 100 (fibrec 10))
[307]

  (bench 100 (fibtail1 50 0 1))
[307 120]
```

Since the recursive call is in tail position, `recall` may be used to trigger tail call optimization.

```
  (func fibtail2 [Int Int Int] [Int]
      (let [n _ a _ b _]
          (if (=0 n) a (if (=1 n) b (recall (-1 n) b (+ a b))))))
[]

  (bench 100 (fibtail2 50 0 1))
[307 120 95]
```

### booleans
Every value has a boolean representation; most are true, but integers are false when zero, strings and stacks when empty etc. 

`and` returns the first argument if false, else the last.

```
  (and 0 t)
[0]

  (and t 42)
[0 42]
```

`or` returns the first argument if true, else the last.

```
  (or 42 f)
[42]

  (or f 42)
[42 42]
```

`not`returns `t` if the argument is false, else `f`.

```
  (not 0)
[t]

  (not 42)
[t f]
```

### pairs
Pairs may be formed using `:`.

```
  1:2
[1:2]
```

### iteration
`for` may be used to iterate any sequence.

```
  (for 3)
[0 1 2]
```

`:` may be used to bind the current value.

```
  (for i:3 i)
[0 1 2]
```

### todo
- add macros
- add string parser
- add string interpolation
    - swift syntax
