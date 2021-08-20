## Swifties REPL

### intro
This projects aims to demonstrate how to implement a custom Lisp with REPL using [Swifties](https://github.com/codr7/swifties).

```
Swifties v4

Return evaluates completed forms,
(reset) clears the stack and Ctrl+D quits.

  (func fibrec [n:Int] [Int]
      (if (< n 2) n (+ (fibrec (-1 n)) (fibrec (-2 n)))))
[]

  (fibrec 10)
[55]
```

### quirks
- The stack is directly exposed to user code, just like in Forth.
- Primitives, Macros and Functions are called on reference with no arguments outside of call forms.
- Parens are used for calls only, brackets for lists of things.

### stacks
`stash` may be used to replace the the stack with its contents as a single item, while `splat` replaces the top item with its items. Any identifier containing only the letter `d`, such as `dd` in the following example, drops that many items from the stack.

```
  (do 1 2 3)
[1 2 3]

  (do 4 stash 5 6)
[[1 2 3 4] 5 6]

  (do dd splat)
[1 2 3 4]
```

Stack literals are enclosed in brackets.

```
  [1 2 3]
[1 2 3]
```

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
  (func fibrec [n:Int] [Int]
      (if (< n 2) n (+ (fibrec (-1 n)) (fibrec (-2 n)))))
[]

  (fibrec 10)
[55]
```
The algorithm can definitely be improved, note that I had to change `n` from `10` to `50` to even get something worth measuring.

```
  (func fibtail1 [n:Int a:Int b:Int] [Int]
      (if (=0 n) a (if (=1 n) b (fibtail1 (-1 n) b (+ a b)))))
[]

  (bench 100 (fibrec 10))
[307]

  (bench 100 (fibtail1 50 0 1))
[307 120]
```

Since the recursive call is in tail position, `recall` may be used to trigger tail call optimization.

```
  (func fibtail2 [n:Int a:Int b:Int] [Int]
      (if (=0 n) a (if (=1 n) b (recall (-1 n) b (+ a b)))))
[]

  (bench 100 (fibtail2 50 0 1))
[307 120 95]
```

#### dots
`.` may be used to shift arguments to the left of the target syntactically.

```
  (1.+ 2)
[3]
```

### multimethods
Functions are upgraded to multimethods as soon as multiple definitions share the same name.
Multimethods delegate to the most specific applicable function, this makes them somewhat more expensive to call.

```
  (func foo [] [String] "n/a")
  (func foo [_:Int] [String] "Int")
  (func foo [_:Any] [String] "Any")
[]

  (foo 42)
["Int"]

  (foo t)
["Int" "Any"]

  (foo)
["Int" "Any" "n/a"]
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

### strings
String literals are enclosed in double quotes.

```
  "foo"
["foo"]
```

### characters
Character literals are prefixed with `#`.

```
  #a
[#a]
```

### pairs
Pairs may be formed using `:`.

```
  1:2
[1:2]
```

### iterators
`for` may be used to iterate any sequence.

```
  (for 3)
[0 1 2]
```

`:` may be used to bind the current value within the loop body.

```
  (for c:"foo" c)
[#f #o #o]
```

`map` may be used to transform sequences.

```
  (map &+1 [1 2 3])
[Iter(0x00007ffee5571a48)]

  (for _)
[2 3 4]
```

### continuations
The current continuation may be captured using `suspend` and evaluated using `restore`.

```
  (do (suspend) 42)
[Cont(2)]

  (restore _)
[42]
```

### todo
- add reference reader
- add macros
