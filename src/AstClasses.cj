package LoxCompiler
import std.collection.*

interface Visitor<R> {
    func visitBinaryExpr(expr: Binary): R
    func visitGroupingExpr(expr: Grouping): R
    func visitLiteralExpr(expr: Literal): R
    func visitUnaryExpr(expr: Unary): R
}
abstract class Expr {
    public func accept<R>(visitor: Visitor<R>): R
}

class Binary <: Expr {
    let left: ?Expr
    let op: Token
    let right: ?Expr

    init(left: ?Expr, op: Token, right: ?Expr) {
        this.left = left
        this.op = op
        this.right = right
    }

    public func accept<R>(visitor: Visitor<R>): R {
        return visitor.visitBinaryExpr(this)
    }
}

class Grouping <: Expr {
    let expression: ?Expr

    init(expression: ?Expr) {
        this.expression = expression
    }

    public func accept<R>(visitor: Visitor<R>): R {
        return visitor.visitGroupingExpr(this)
    }
}

class Literal <: Expr {
    let value: ?Any

    init(value: ?Any) {
        this.value = value
    }

    public func accept<R>(visitor: Visitor<R>): R {
        return visitor.visitLiteralExpr(this)
    }
}

class Unary <: Expr {
    let op: Token
    let right: ?Expr

    init(op: Token, right: ?Expr) {
        this.op = op
        this.right = right
    }

    public func accept<R>(visitor: Visitor<R>): R {
        return visitor.visitUnaryExpr(this)
    }
}