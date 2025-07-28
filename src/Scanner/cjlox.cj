package LoxCompiler

import std.fs.*
import std.env.*

import std.io.*
import std.collection.*
import std.os.process.*

public class Lox {
    static hadError: Bool = false

    private static func run(source: String) {
        scanner: Scanner = Scanner(source)
        List<Token> tokens = scanner.scanTokens()

        for (token: Token in tokens) {
            println(token)
        }
    }

    private static func runFile(path: String) {
        try {
            let bytes: Array<Byte> = readFrom(path)
            run(String.fromUtf8(bytes))
            if (hadError) {
                Process.current.exit(65)
            }
        } catch (e: Exception) {
            println(e)
        }
    }

    private static func runPrompt() {
        stdIn = getStdIn()

        do{
            println("> ")
            line: Option<String> = stdIn.readln()
            if (line == "") {
                break
            }
            run(line)
            hadError = false;
        }while(true)
    }


    public static func main(args: List<String>): Int64 {
        if(args.size > 1) {
            println("Usage: jlox [script]")
            Process.current.exit(64)
        }else if (args.size == 1) {
            runFile(args[0])
        }else {
            runPrompt()
        }
        return 0
    }

    static func error(line: int, message: String) {
        report(line, "", message)
    }

    private static func report(line: int, place: String, message:String) {
        println( "[line: ${line}] Error ${place} : ${message}" )
        hadError = true
    }
}

