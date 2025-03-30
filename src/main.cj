macro package defer

import std.ast.*
public import std.collection.ArrayList

public macro DeferWarp(input: Tokens): Tokens {
    let funcDecl = FuncDecl(input)
    try {
        funcDecl.declType
    } catch (e: Exception) {
        diagReport(DiagReportLevel.ERROR, quote($(funcDecl.identifier)), "使用DeferWarp包裹的方法需要明确定义返回类型",
            "访方法需要明确定义返回类型")
    }
    // 修饰符
    var modifiers = quote()
    if (funcDecl.modifiers.size > 0) {
        modifiers = quote($(funcDecl.modifiers))
    }
    // 泛形参数
    var generic = quote()
    if (funcDecl.isGenericDecl) {
        generic = quote($(funcDecl.genericParam))
    }
    // 泛形约束
    var genericConstraint = quote()
    if (funcDecl.genericConstraint.size > 0) {
        genericConstraint = quote($(funcDecl.genericConstraint[0]))
    }
    return quote(
        $(modifiers) func $(funcDecl.identifier)$(generic)($(funcDecl.funcParams)) $(genericConstraint) {
            let __deferfns = ArrayList<()->Unit>()
            var __result:?$(funcDecl.declType) = None
            var err:?Exception = None
            // 执行warp的方法
            try {
                __result = { =>
                    $(funcDecl.block.nodes)
                }()
            } catch(e:Exception) {
                err = e
            }
            // 执行defer注册的方法
            __deferfns.reverse()
            for (fn in __deferfns) {
                fn()
            }
            // 如果有异常继续抛出
            if (let Some(v) <- err) {
                throw v
            }
            // 返回结果
            return __result.getOrThrow()
        }
    )
}

public macro Defer(input: Tokens): Tokens {
    assertParentContext("DeferWarp")
    return quote(__deferfns.add({ =>
        $(input)
    }))
}
