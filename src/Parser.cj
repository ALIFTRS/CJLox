package LoxCompiler

import std.collection.*

class Parser {
    private let tokens: ArrayList<Token>
    private var current = 0

    init(tokens: ArrayList<Token>) {
        this.tokens = tokens
    }

    private func expression(): ?Expr {
        return equality()
    }

    private func equality(): ?Expr {
        var expr: ?Expr = comparison()

        while (matches(TokenType.BANG_EQUAL, TokenType.EQUAL_EQUAL)) {
            var op: Token = previous()
            var right: ?Expr = comparison()
            expr = Binary(expr, op, right)
        }

        return expr
    }

    private func matches(types: Array<TokenType>): Bool {
        for (typ in types) {
            if(check(typ)) {
                advance()
                return true
            }
        }

        return false
    }

    private func check(typ: TokenType): Bool {
        if (isAtEnd()) {return false}
        return peek().typ == typ
    }

    private func advance() {
        if (!isAtEnd()) {current++}
        return previous()
    }

    private func isAtEnd(): Bool {
        return peek().typ == TokenType.EOF
    }

    private func peek() {
        return tokens[current]
    }

    private func previous() {
        return tokens[current-1]
    }

    private func comparison(): Option<Expr> {
        var expr: ?Expr = term()

        while (matches(TokenType.GREATER, TokenType.GREATER_EQUAL, TokenType.LESS, TokenType.LESS_EQUAL)) {
            var op: Token = previous()
            var right: ?Expr = term()
            expr = Binary(expr, op, right)
        }

        return expr
    }

    private func term(): ?Expr {
        var expr: ?Expr = factor()

        while(matches(TokenType.MINUS, TokenType.PLUS)) {
            var op: Token = previous()
            var right: ?Expr = factor()
            expr =  Binary(expr, op, right)
        }

        return expr
    }

    private func factor(): ?Expr {
        var expr: ?Expr = unary()

        while(matches(TokenType.SLASH,TokenType.STAR)) {
            let op: Token = previous()
            let right: ?Expr = unary()
            expr = Binary(expr, op, right)
        }

        return expr
    }

    private func unary(): Option<Expr> {
        if (matches(TokenType.BANG, TokenType.MINUS)) {
            let op: Token = previous()
            let right: ?Expr = unary()
            return Unary(op, right)
        }

        return primary()
    }

    private func primary(): Option<Expr> {
        if (matches(TokenType.FALSE)) {return Literal(false)}
        if (matches(TokenType.TRUE)) {return Literal(true)}
        if (matches(TokenType.NIL)) {return Literal("")}

        if (matches(TokenType.NUMBER, TokenType.STRING)) {
            return Literal(previous().literal.getOrThrow())
        }

        if (matches(TokenType.LEFT_PAREN)) {
            let expr: ?Expr = expression()
            consume(TokenType.RIGHT_PAREN, "Expect ')' after expression.")
            return Grouping(expr)
        }

        error(peek(), "Expect expression.")

        return None
    }

    private func consume(typ: TokenType, message: String) {
        if (check(typ)) {return advance()}
        error(peek(), message)
    }

    private func error(token: Token, message:String) {
        Lox.error(token, message)
        return
    }

    private func synchronize() {
        advance()

        while (!isAtEnd()) {
            if (previous().typ == TokenType.SEMICOLON) {return}

            match (peek().typ) {
                case TokenType.CLASS | TokenType.FUN | TokenType.VAR | TokenType.FOR | TokenType.IF | TokenType.WHILE | TokenType.PRINT | TokenType.RETURN => return
                case _ => continue
            }
        }

        advance()
    }

    public func parse(): ?Expr {
        return expression()     
    }

}