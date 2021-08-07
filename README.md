## Swifties REPL

### intro
This projects aims to demonstrate how to implement a custom Lisp with REPL using [Swifties](https://github.com/codr7/swifties).

```
Swifties v1

Hitting Return evaluates once the form is complete,
(reset) clears the stack and Ctrl+D quits.

1  (do 1 2 3)
[1 2 3]
2  (do 4 stash 5 6)
[[1 2 3 4] 5 6]
3  (do drop drop splat)
[1 2 3 4]
```

### quirks
- The stack is directly exposed to user code, just like in Forth.
- Primitives, Macros and Functions are called on reference with no arguments outside of call forms.
- Parens are used for calls only, brackets for lists of things.
- There's no syntax yet for automagically binding function arguments, think Perl until recently.

### bindings
Values may be bound to identifiers once per scope using `let`.

```
1  (let [x 35 y 7]
1      (+ x y))
[42]
```

### functions
New functions may be defined using `func`.

```
1  (func fibrec [Int] [Int]
1      (let [n _]
1          (if (< n 2) n (+ (fibrec (- n 1)) (fibrec (- n 2))))))
[]
2  (fibrec 20)
[6765]
```
The algorithm can definitely be improved, note that I had to change `n` from `10` to `50` to even get something worth measuring.

```
1  (func fibtail-1 [Int Int Int] [Int]
1      (let [n _ a _ b _]
1          (if (= n 0) a (if (= n 1) b (fibtail-1 (- n 1) b (+ a b))))))
[]
2  (bench 100 (fibrec 10))
[6765 360]
3  (bench 100 (fibtail-1 50 0 1))
[6765 360 162]
```

Since the only recursive call is in tail position, `recall` may be used to trigger tail call optimization.

```
1  (func fibtail-2 [Int Int Int] [Int]
1      (let [n _ a _ b _]
1          (if (= n 0) a (if (= n 1) b (recall (- n 1) b (+ a b))))))
[]
2  (bench 100 (fibtail-2 50 0 1))
[6765 360 162 138]
```

### todo
- add macros
- add string parser
- add string interpolation
    - swift syntax
- add syntax for func arg names
