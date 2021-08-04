import Foundation
import Swifties

let env = Env()
var input = ""

print("Swifties v1\n\n")

while true {
    print("  ")
    let line = readLine()
    if line == nil { break }
    
    if line! == "" {
        let parser = Parser(env: env, source: "repl",
                            spaceReader, idReader)
        
        try parser.read(&input)
        let startPc = env.pc
        for f in parser.forms { try f.emit() }
        try env.eval(pc: startPc)
    } else {
        input += line!
    }
    
    //TODO Print stack
}
