package LoxCompiler

class Token <: toString {
    let typ: TokenType
    let lexeme: String
    let literal: Object
    let line: Int16

    init(typ: TokenType, lexeme: String, literal: Object, line: int) {
        this.typ = typ;
        this.lexeme = lexeme;
        this.literal = literal;
        this.line = line;
    }

    public func toString(): String {
        "${typ} ${lexeme} ${literal}"
    }

}