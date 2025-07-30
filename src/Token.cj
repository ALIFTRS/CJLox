package LoxCompiler

class Token <: ToString {
    let typ: TokenType
    let lexeme: String
    let literal: Option<Any>
    let line: Int16

    init(typ: TokenType, lexeme: String, literal: Option<Any>, line: Int16) {
        this.typ = typ;
        this.lexeme = lexeme;
        this.literal = literal;
        this.line = line;
    }

    public func toString(): String {
        if (literal.isSome()) {
            return "${typ} ${lexeme}"
        } else {
            return "${typ} ${lexeme} None"
        }
    }

}