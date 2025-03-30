# 仓颉 defer 宏

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## 概述

本项目通过仓颉编程语言的宏系统实现了类似 Go 语言的 `defer` 机制，提供了一种简洁可靠的资源管理方式。该实现支持跨作用域延迟执行、后进先出执行顺序，并与异常处理机制良好兼容。

## 核心特性

- **仿 Go 语义**：完整复刻 Go 语言 defer 的后进先出特性
- **智能作用域管理**：自动绑定延迟代码到当前作用域生命周期
- **异常安全**：在异常抛出时仍保证已注册 defer 的执行
- **轻量级实现**：基于宏系统实现，无额外运行时开销

## 快速开始

### 安装集成

```toml
[dependencies]
  defer = { git = "https://github.com/ystyle/defer", branch = "master"}
```


### 基础用法

1. 方法签名要完整声明，本宏不支持类型推断
```cj
@DeferWarp
public func myFunc():Int64 {
   @Defer(println("defer1"))
   let a:Int64 = 1
   @Defer(println("defer2: a = ${a}"))
   println(a)
   return a
}
// out: 
// 1
// defer2: a = 1
// defer1
```

2. 代码抛出异常时也能正常按顺序执行defer的代码
```cj
@DeferWarp
func withException():Unit {
    @Defer(println("defer1"))
    throw Exception("出错了")
    @Defer(println("defer2"))
}
// out: 
// defer1
// An exception has occurred:
// Exception: 出错了
//         at example.withException::lambda.0()(/home/ystyle/Projects/defer-cj/example/src/main.cj.macrocall:183)
//         at example.withException()(/home/ystyle/Projects/defer-cj/example/src/main.cj.macrocall:181)
//         at example.main()(/home/ystyle/Projects/defer-cj/example/src/main.cj.macrocall:23)
```

## 注意事项

1. **变量捕获**：defer 语句在是lambda表达式执行的， 捕获的是应该是不可变的变量
2. **性能影响**：建议避免在性能敏感循环中频繁注册 defer
3. **作用域限制**：不支持跨协程 defer 注册和执行

## 许可协议

本项目基于 [木兰 许可证](LICENSE) 开源，详情参见许可文件。
