%2018-Jan-04 Year of Scala - REPL

#REPL - Read-Eval-Print-Loop 

A REPL give the user an interactive programming environment that 1) Reads the user input, 2) evaluates the express, 3) prints the result, 4) Loops back to read the next expression.

sbt/Scala provides a Repl, and this is where we'll be beginning. 

```
$ sbt console
OpenJDK 64-Bit Server VM warning: ignoring option MaxPermSize=384m; support was removed in 8.0
[info] Set current project to... 
[info] Starting scala interpreter...
[info] 
Welcome to Scala version 2.10.3 (OpenJDK 64-Bit Server VM, Java 1.8.0_151).
Type in expressions to have them evaluated.
Type :help for more information.

scala> 1 + 2
res0: Int = 3
```

The result of the expression is automatically saved in a value named "res" with an auto incrementing suffix.

```
scala> res0
res1: Int = 3

```

#Values & Variables

Values and Variables bind the evaluated result of the expression to a name. The difference between them being, that values are not mutable.

```
scala> val i:Int = 0
i: Int = 0

scala> i = 1
<console>:8: error: reassignment to val
       i = 1
         ^

scala> var j:Int = 0
j: Int = 0

scala> j = 1
j: Int = 1

```

In Scala, the compiler is your friend. Since the expressions are evaluated at compile time, the compiler infers the result type based on the result type of the expression. This is known as [Type Inference](https://en.wikipedia.org/wiki/Type_inference) and is a feature..


```
scala> val i = 0
i: Int = 0

scala> val i = 0.0
i: Double = 0.0

```

The expression "0" is evaluated and the compiler infers it's of type "Int" therefore, the value "i" will be set to that type. There is no need to explicitly declare the type. However, in some cases it may improve the readability of your code.

#Definitions 
A function can be declared as a definition. Definitions differ from values, in that values are evaluated when defined, where as definitions are only evaluated on every call. The only exception being "lazy values" which are evaluated the first time they are used.

```
scala> def plusOne(x: Int) = x + 1
plusOne: (x: Int)Int

scala> val three = plusOne(2)
three: Int = 3
```

Functions that have multiple expressions can be wrapped in a { }. The final expression in the block is the resultant type of the code block. There is no "return", just a result of the expression. 

```
scala> def plusTwo(x:Int) = { 
     | val first = plusOne(x)
     | val second = plusOne(first)
     | second
     | }
plusTwo: (x: Int)Int

scala> val three = plusTwo(1)
three: Int = 3
```


## Nested Functions

You can indeed have functions defined inside of functions. This can be beneficial when encapsulating the implementation.

```
scala> def plusTwo(x:Int) = {
     |   def plusOne(y:Int) = y + 1
     |   plusOne(plusOne(x))
     | }
plusTwo: (x: Int)Int

scala> plusTwo(1)
res9: Int = 3

```

