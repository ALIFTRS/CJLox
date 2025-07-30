package LoxCompiler

import std.fs.*
import std.env.*

import std.io.*
import std.collection.*
import std.process.*

public class Lox {
    static var hadError: Bool = false

    private static func run(source: String) {
        println(source)
        var scanner: Scanner = Scanner(source)
        let tokens = scanner.scanTokens()

        let parser: Parser = Parser(tokens)
        let expression: ?Expr = parser.parse()

        if (hadError) {return}
        println(AstPrinter().print(expression.getOrThrow()))

        // for (token in tokens) {
        //     println(token)
        // }
    }

    public static func runFile(path: String) {
        try {
            let bytes = File.readFrom(path)
            run(String.fromUtf8(bytes))
            if (hadError) {
                Process.current.exit(65)
            }
        } catch (e: Exception) {
            println(e)
        }
    }

    public static func runPrompt() {
        let stdIn = getStdIn()

        do{
            println("> ")
            var line: Option<String> = stdIn.readln()
            if (line == "") {
                break
            }
            run(line.getOrThrow())
            hadError = false;
        }while(true)
    }

    static func error(line: Int16, message: String) {
        report(line, "", message)
    }

    private static func report(line: Int16, place: String, message:String) {
        println( "[line: ${line}] Error ${place} : ${message}" )
        hadError = true
    }

    static func error(token: Token, message: String) {
        if(token.typ == TokenType.EOF) {
            report(token.line, " at end", message)
        } else {
            report(token.line, " at '${token.lexeme}'", message)
        }
    }
}

main(): Int64 {
    Lox.runFile("src/testlox.txt")
        // if(args.size > 1) {
        //     println("Usage: jlox [script]")
        //     Process.current.exit(64)
        // }else if (args.size == 1) {
        //     Lox.runFile(args[0])
        // }else {
        //     Lox.runPrompt()
        // }
    return 0
    }