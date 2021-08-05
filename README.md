## Swifties REPL

### intro
This projects aims to serve as a demonstration of how to implement a custom language using [Swifties](https://github.com/codr7/swifties/tree/main/Sources/Swifties/types).

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

### bindings

```
1  (let [x 35 y 7]
1      (+ x y))
[42]
```

### functions

```
1  (func fib [n Int] [Int]
1      (if (< n 2) n (+ (fib (- n 1) (fib (- n 2))))))
[]
2  (fib 20)
[6765]
```
