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
1  (func fib [Int] [Int]
1      (let [n _]
1          (if (< n 2) n (+ (fib (- n 1)) (fib (- n 2))))))
[]
2  (fib 20)
[6765]
```
