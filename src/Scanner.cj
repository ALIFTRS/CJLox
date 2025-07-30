package LoxCompiler

import std.collection.*
import std.convert.*

class Scanner {
    private let source: String
    private let tokens: ArrayList<Token> = ArrayList<Token>()

    private var start = 0
    private var current = 0
    private var line: Int16 = 1


    private static let keywords = HashMap<String, TokenType>()


    init(source: String) {
        this.source = source
        keywords["and"] = TokenType.AND
        keywords["class"] = TokenType.CLASS
        keywords["else"] = TokenType.ELSE
        keywords["false"] = TokenType.FALSE
        keywords["for"] = TokenType.FOR
        keywords["fun"] = TokenType.FUN
        keywords["if"] = TokenType.IF
        keywords["nil"] = TokenType.NIL
        keywords["or"] = TokenType.OR
        keywords["print"] = TokenType.PRINT
        keywords["return"] = TokenType.RETURN
        keywords["super"] = TokenType.SUPER
        keywords["this"] = TokenType.THIS
        keywords["true"] = TokenType.TRUE
        keywords["var"] = TokenType.VAR
        keywords["while"] = TokenType.WHILE

    }

    func scanTokens() {
        while (!isAtEnd()) {
            start = current
            scanToken()
        }
        tokens.add(Token(TokenType.EOF, "", None, line))
        tokens
    }

    private func scanToken() {
        let c: Rune = advance()
        match (c) {
            case '(' => addToken(TokenType.LEFT_PAREN)
                        
            case ')' => addToken(TokenType.RIGHT_PAREN)
                        
            case '{' => addToken(TokenType.LEFT_BRACE)
                        
            case '}' => addToken(TokenType.RIGHT_BRACE)
                        
            case ',' => addToken(TokenType.COMMA)
                        
            case '.' => addToken(TokenType.DOT)
                        
            case '-' => addToken(TokenType.MINUS)
                        
            case '+' => addToken(TokenType.PLUS)
                        
            case ';' => addToken(TokenType.SEMICOLON)
                        
            case '*' => addToken(TokenType.STAR)
                        
            case '!' => addToken(
                        if(matches(r'=')){
                            TokenType.BANG_EQUAL
                        }else {
                            TokenType.BANG
                        }
            )
                        
            case '=' => addToken(
                        if(matches(r'=')){
                            TokenType.EQUAL_EQUAL
                        }else {
                            TokenType.EQUAL
                        }
            )
                        
            case '<' => addToken(
                        if(matches(r'=')){
                            TokenType.LESS_EQUAL
                        }else {
                            TokenType.LESS
                        }
            )
                        
            case '>' => addToken(
                        if(matches(r'=')){
                            TokenType.GREATER_EQUAL
                        }else {
                            TokenType.GREATER
                        }
            )
                        
            
            case '/' => if(matches(r'/')) {
                            while (peek() != r'\n' && !isAtEnd()) {advance()}
                        } else {
                            addToken(TokenType.SLASH)
                        }

            case '\n' => line++

            case ' '  => return
                         
            
            case '"'  => string()
                         
            
            case  _  => if (isDigit(c)) {
                            number()
                        } else if (isAlpha(c)) {identifier()
                        } else {
                        Lox.error(line, "Unexpected character.")
                        }
                        
        }
    }

    private func identifier() {
        while (isAlphaNumeric(peek())) { advance()}
        let text : String = source.toRuneArray()[start..current].toString()
        var typ: Option<TokenType> = keywords.get(text)

        if(typ.isNone()) {typ = TokenType.IDENTIFIER}
        addToken(typ.getOrThrow())
    }

    private func number() {
        while (isDigit(peek())) { advance()}

        if (peek() == r'.' && isDigit(peekNext())) {
            // Consume the "."
            advance()
            while (isDigit(peek())) {advance()}
        }
        addToken(TokenType.NUMBER, Float64.parse(source[start..current].toString()))
    }


    private func string() {
        while(peek() != r'"' && !isAtEnd()) {
            if (peek() == r'\n') {line++}
            advance()
        }

        if(isAtEnd()) {
            Lox.error(line, "Unterminated String.")
            return
        }

        advance()

        let value: String = source[start+1..current-1].toString()
        addToken(TokenType.STRING, value)
    }

    // private func cStyleComment() {
    //     var counter = 1
    //     while ( peek() != r'*' && peek() != r'/' && !isAtEnd()) {
    //         if (peek() == r'\n') {line++}
    //         advance()
    //     }

    //     if(isAtEnd()) {
    //         Lox.error(line, "Unterminated C-Style comment")
    //         return
    //     }
        

    // }

    private func matches(expected: Rune) {
        if(isAtEnd()) {
            return false
        }
        if(source.toRuneArray()[current] != expected) {
            return false
        }
        current++
        return true
    }

    private func peek(): Rune {
        if (isAtEnd()) {
            return r'\0'
        }
        return source.toRuneArray()[current]
        
    }

    private func peekNext(): Rune {
        if (current+1 >= source.size) {return r'\0'}
        return source.toRuneArray()[current + 1]
    }

    private func isAlpha(c: Rune) {
        return ((c >= r'a' && c <= r'z') ||
                (c >= r'A' && c <= r'Z') ||
                 c == r'_')
    }

    private func isAlphaNumeric(c: Rune) {
        return isAlpha(c) || isDigit(c)
    }

    private func isDigit(c: Rune): Bool {
        return c >= r'0' && c <= r'9'
    }

    private func isAtEnd(): Bool {
        current >= source.size
    }

    private func advance(): Rune {
        let charToReturn = source.toRuneArray()[current]
        current++
        return charToReturn
    }

    private func addToken(typ: TokenType) {
        addToken(typ, "")
    }

    private func addToken(typ: TokenType, literal: Any) {
        let text: String = source[start..current]
        tokens.add(Token(typ, text, literal, line))
    }

    
}
