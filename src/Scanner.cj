package LoxCompiler

import std.collection.*

import LoxCompiler.TokenType.*

class Scanner {
    private let source: String
    private let tokens: ArrayList<Token> = ArrayList<Token>()

    private var start = 0
    private var current = 0
    private var line = 1

    init(source: String) {
        this.source = source
    }

    mut func scanTokens() {
        while (!isAtEnd()) {
            start = current
            scanToken()
        }

        tokens.add(Token(EOF, "", None, line))
        tokens
    }

    private func scanToken() {
        c: Rune = advance()
        match (c) {
            case '(' => addToken(LEFT_PAREN)
                        break
            case ')' => addToken(RIGHT_PAREN)
                        break
            case '{' => addToken(LEFT_BRACE)
                        break
            case '}' => addToken(RIGHT_BRACE)
                        break
            case ',' => addToken(COMMA)
                        break
            case '.' => addToken(DOT)
                        break
            case '-' => addToken(MINUS)
                        break
            case '+' => addToken(PLUS)
                        break
            case ';' => addToken(SEMICOLON)
                        break
            case '*' => addToken(STAR)
                        break
            case '!' => addToken(
                        if
            )
                        break
            case '=' =>
                        addToken
                        break
            case '<' =>
                        addToken
                        break
            case '>' =>
                        addToken
                        break
            
            case  _  => cjlox.error(line, "Unexpected character.")
                        break
        }
    }

    private func matches(expected: Rune) {
        if(isAtEnd()) {
            return false
        }
        if(source[current] != expected) {
            return false
        }
        current++
        return true
    }

    private func isAtEnd(): Bool {
        current >= source.length()
    }

    mut private func advance() {
        source[current++]
    }

    private func addToken(typ: TokenType) {
        addToken(typ, None)
    }

    private func addToken(typ: TokenType, literal: Object) {
        text: String = source[start..current]
        tokens.add(Token(typ, text, literal, line))
    }


    
}
