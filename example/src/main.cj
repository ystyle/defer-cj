package example

import std.collection.ArrayList
import defer.*

main() {
    println("myFunc:")
    myFunc()

    println("\nnoArgs:")
    noArgs()

    println("\nwithArgs:")
    withArgs(1, "dddd")

    println("\nwithGeneric:")
    withGeneric<Int64>(1)

    println("\nwithGenericConstraint:")
    withGenericConstraint<Int64>(1)

    println("\nwithException:")
    withException()
}


@DeferWarp
public func myFunc():Int64 {
   @Defer(println("defer1"))
   let a:Int64 = 1
   @Defer(println("defer2: a = ${a}"))
   println(a)
   return a
}

@DeferWarp
func noArgs():Unit {
    @Defer(println("defer1"))
}

@DeferWarp
func withArgs(i:Int64, b:String):Unit {
    @Defer(println("defer1"))
    println(i)
}

@DeferWarp
func withGeneric<T>(i:T):Unit {
    @Defer(println("defer1"))
}

@DeferWarp
func withGenericConstraint<T>(i:T):Unit where T<: ToString & Comparable<T> {
    @Defer(println("defer1"))
    println(i)
}

@DeferWarp
func withException():Unit {
    @Defer(println("defer1"))
    throw Exception("出错了")
    @Defer(println("defer2"))
}