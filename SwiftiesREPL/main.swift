import Foundation
import Swifties

print("Swifties v\(SWIFTIES_VERSION)\n")
print("Hitting Return evaluates once the form is complete,")
print("(reset) clears the stack and Ctrl+D quits.\n")
print("May the Source be with you!\n")

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
    try parser.slurp(line!)
    let forms = parser.forms
    
    if forms.count > 0 && parser.input.count == 0 {
        let startPc = env.pc
        for f in forms { try f.emit() }
        env.emit(STOP)
        try env.eval(pc: startPc)
        print("\(env.coreLib!.stackType.dumpValue!(env.stack))")
        parser.reset()
        prompt += 1
    }
}
