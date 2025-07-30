package LoxCompiler

class AstPrinter <: Visitor<String> {

    public func print(expr: Expr) {
        return expr.accept(this)
    }

    public func visitBinaryExpr(expr: Binary): String {
        return parenthesize(expr.op.lexeme, expr.left, expr.right)
    }

    public func visitGroupingExpr(expr: Grouping): String {
        return parenthesize("group", expr.expression)
    }

    public func visitLiteralExpr(expr: Literal) {
        if (let Some(e) <- expr.value) {return (expr.value.getOrThrow() as ToString).getOrThrow().toString()}
        return "nil"
    }

    public func visitUnaryExpr(expr: Unary): String {
        return parenthesize(expr.op.lexeme, expr.right)
    }

    private func parenthesize(name: String, exprs: Array<?Expr>): String {
        var builder = "(" + name
        for (expr in exprs) {
            builder += " "
            builder += expr.getOrThrow().accept(this)
        }
        builder += ")"
        return builder
    }
}