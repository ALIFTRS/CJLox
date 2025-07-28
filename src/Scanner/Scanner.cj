package LoxCompiler

import std.collection.*

import LoxCompiler.TokenType.*

class Scanner {
    private let source: String
    private let tokens: ArrayList<Token> = ArrayList<Token>()

    private var start = 0
    private var current = 0
    private var line = 1


    private static let keywords = HashMap<String, TokenType>()

    keywords.put("and",    AND);
    keywords.put("class",  CLASS);
    keywords.put("else",   ELSE);
    keywords.put("false",  FALSE);
    keywords.put("for",    FOR);
    keywords.put("fun",    FUN);
    keywords.put("if",     IF);
    keywords.put("nil",    NIL);
    keywords.put("or",     OR);
    keywords.put("print",  PRINT);
    keywords.put("return", RETURN);
    keywords.put("super",  SUPER);
    keywords.put("this",   THIS);
    keywords.put("true",   TRUE);
    keywords.put("var",    VAR);
    keywords.put("while",  WHILE);


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
                        if(matches('=')){
                            BANG_EQUAL
                        }else {
                            BANG
                        }
            )
                        break
            case '=' => addToken(
                        if(matches('=')){
                            EQUAL_EQUAL
                        }else {
                            EQUAL
                        }
            )
                        break
            case '<' => addToken(
                        if(matches('=')){
                            LESS_EQUAL
                        }else {
                            LESS
                        }
            )
                        break
            case '>' => addToken(
                        if(matches('=')){
                            GREATER_EQUAL
                        }else {
                            GREATER
                        }
            )
                        break
            
            case '/' => if(matches('/')) {
                            while (peek() != '\n' && !isAtEnd()) {advance()}
                        } else {
                            addToken(SLASH)
                        }
                        break

            case ' '|'\r'|'\t' => break

            case '\n' => line++
                         break
            
            case '"'  => string()
                         break
            
            case  _  => if (isDigit(c)) {
                            number()
                        } else if {
                            (isAlpha(c)) { identifier()}
                        } else {
                        cjlox.error(line, "Unexpected character.")
                        }
                        break
        }
    }

    private func identifier() {
        while (isAlphaNumeric(peek())) { advance()}
        text : String = source[start..current]
        typ: Option<TokenType> = keywords.get(text)

        if(typ == None) {typ = IDENTIFIER}
        addToken(typ)
    }

    private func number() {
        while (isDigit(peek())) { advance()}

        if (peek() == '.' && isDigit(peekNext())) {
            // Consume the "."
            advance()
            while (isDigit(peek())) {advance()}
        }

        addToken(NUMBER, Double.parseDouble(source[start..current]))
    }


    private func string() {
        while(peek() != '"' && !isAtEnd()) {
            if (peek() == '\n') {line++}
            advance()
        }

        if(isAtEnd()) {
            cjlox.error(line, "Unterminated String.")
            return
        }

        advance()

        value: String = source[start+1..current-1]
        addTOken(STRING, value)
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

    private func peek() {
        if (isAtEnd()) {
            return '\0'
        } else {
            return source[current]
        }
    }

    private func peekNext() {
        if (current+1 >= source.size) return '\0'
        return source[current + 1]
    }

    private isAlpha(c: Rune) {
        return ((c >= 'a' && c <= 'z') |
                (c >= 'A' && c <= 'Z') |
                 c == '_')
    }

    private isAlphaNumeric(c: Rune) {
        return isAlpha(c) | isDigit(c)
    }

    private func isDigit(c: Rune): Bool {
        return c >= '0' && c <= '9'
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
