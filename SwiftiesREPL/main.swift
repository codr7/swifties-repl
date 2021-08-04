import Foundation
import Swifties

print("Swifties v\(SWIFTIES_VERSION)\n")
print("Hit Return on empty line to evaluate.")
print("(reset) clears the stack and Ctrl+D quits.\n")

let env = Env()
env.beginScope()
let initPos = Pos("repl init")
try env.initCoreLib(pos: initPos)
try env.coreLib!.bind(pos: initPos)
try MathLib(env: env, pos: initPos).bind(pos: initPos)

let parser = Parser(env: env, source: "repl",
                    spaceReader, idReader)

var prompt = 1
var input = ""

while true {
    print("\(prompt)  ", terminator: "")
    let line = readLine()
    if line == nil { break }
    input += line!

    if line! == "" {
        try parser.read(&input)
        
        if input != "" {
            print("Unrecognized input: \(input)")
            input = ""
        }
        
        let forms = parser.forms
        parser.reset()
        let startPc = env.pc
        for f in forms { try f.emit() }
        env.emit(STOP)
        try env.eval(pc: startPc)
        print("\(env.coreLib!.stackType.dumpValue!(env.stack))")
        prompt += 1
    }
}
