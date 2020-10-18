% Year of Scala - REPL

###REPL - Read-Eval-Print-Loop 

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

###Values & Variables

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

###Functions
A function can be declared as a definition. Definitions differ from values in that values are evaluated when defined, where as definitions are only evaluated on every call. The only exception being "lazy values" which are evaluated the first time they are used.

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


### Nested Functions

You can indeed have functions defined inside of functions. This can be beneficial when encapsulating the implementation. For example, if you want to write a tail recursive version of the parent function.

```
scala> def plusTwo(x:Int) = {
     |   def plusOne(y:Int) = y + 1
     |   plusOne(plusOne(x))
     | }
plusTwo: (x: Int)Int

scala> plusTwo(1)
res9: Int = 3

```

### Higher-Order Functions

In Scala functions are a first-class values. You can define a value that is a function, define a function that takes a function, or returns a function as the result of the expression.

For example:

```
scala> val plusOne = (x:Int) => x + 1
plusOne: Int => Int = <function1>
```

plusOne has the type <code>Int => Int</code>. This means, that plusOne is a function that takes an Int and returns an Int. This function can be passed to another function as a parameter since functions are types.

```
scala> def addOne(x:Int, y: Int => Int) = y(x)
addOne: (x: Int, y: Int => Int)Int

scala> addOne(1, plusOne)
res0: Int = 2

```

The function plusOne is being passed to the function addOne, which simply executes function. This is very powerful since this allows us to apply different behavior to an existing function. 

Let's see how we can use this to our advantage. Let's say we have a function that looks through a list of ints and returns all the ones. 
```
scala> def findOnes(ls:List[Int]):List[Int] = {
     |   ls match {
     |     case Nil => Nil
     |     case x::xs => if (x == 1) x::findOnes(xs) else findOnes(xs)
     |   }
     | }
findOnes: (ls: List[Int])List[Int]

scala> findOnes(List(1,2,3,1))
res5: List[Int] = List(1, 1)

scala> findOnes(List())
res6: List[Int] = List()

```

Great, now how about if we have to find all the numbers greater than 4? or all the numbers equal to 2? We can genearlize this by taking predicate as a function that takes two Ints and returns a boolean. 

```
scala> def find( ls:List[Int], fn: (Int) => Boolean):List[Int]= {
     |   ls match {
     |     case Nil => Nil
     |     case x::xs => if (fn(x)) x::find(xs,fn) else find(xs, fn)
     |   }
     | }
find: (ls: List[Int], fn: Int => Boolean)List[Int]

scala> find(List(1,2,3,1), { x => x == 1 })
res3: List[Int] = List(1, 1)

scala> find(List(1,2,3,1), { x => x > 2 })
res4: List[Int] = List(3)
```

Higher order functions allows us to pass behavior into an already existing function. This will greatly increase code reuse.

### Recursive Functions

In the previous example, I wrote a function that calls itself. Why are they useful? They provide a great benefit by preventing mutation. It does this by utilizing the function stack to store local values and parameters.

Let's look at a recusrive function:

```
scala> def power(x:Int, n:Int): Int = {
     |   if (n == 0) 1 // anything to the 0th power is 1
     |   else x * power(x, n-1)
     | }
power: (x: Int, n: Int)Int

scala> power(2,3)
res0: Int = 8

scala> power(4,0)
res1: Int = 1
```

In all recursive funcitons, you need a base case, in this case, we use when n is equal to 0. The recursive case calls itself with but with a subset of the problem. In the power function, we use n as the number of times x should be multipled by.

```
power(2, 3)
x = 2, n = 3
2 * power (2, 2)
2 * 2 * power(2, 1)
2 * 2 * 2 * power(2,0)
2 * 2 * 2 * 1
8
```

Each time, we're not modifying n, but essentially creating a copy of it when calling the function. But what about the case where n is absurdly large? We'll essentially run out stack frames and overflow the stack. To solve this scenario, Scala has a feature called Tail Recursion.

### Tail Recursion 
Tail recursion relies on storing the intermediate values as a function parameters. In the power example, we only knew the result when ALL the calls to power were complete requiring all the previous results and the accompanying function stack frame. Let's rewrite the power function to support tail recursion.

```
scala> def power(x:Int, n:Int): Int = {
     |   @annotation.tailrec
     |   def _power(x:Int, n:Int, accum:Int): Int = {
     |     if (n == 0) accum
     |     else _power(x, n-1, x * accum)
     |   }
     |  _power(x,n,1)
     | }
power: (x: Int, n: Int)Int
```

This utilizes a Scala feature called annotations, that tells the compiler that the intermediate results are not handled already and the intermediate stack frames can be reclaimed (or not even allocated in the first place).

Let's see how this example plays out. Notice, that I created a nested function to hide the fact that we're using tail recursion here. 

```
_power(2, 3, 1)
x = 2, n = 3, accum = 1
x = 2, n = 2, accum = 2
x = 2, n = 1, accum = 4
x = 2, n = 0, accum = 8
recusion ends, and accum is the final result
```

You can see, we didn't need to wait for all the other function calls to complete, we already had the result!

This function can be modified by using another Scala feature: parameters with default values.

```
scala> @annotation.tailrec
     | def power(x:Int, n:Int, accum:Int = 1): Int = {
     |   if (n == 0) accum
     |   else power(x, n-1, x * accum)
     | }
  
power: (x: Int, n: Int, accum: Int)Int

scala> power(2,3)
res6: Int = 8
```

Notice that when we called the function, we left out the last parameter, in this case the default value is used. The downside of this, is now we are exposing that implementation detail. 

_2018-Jan-04_
