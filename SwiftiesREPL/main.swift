import Foundation
import Swifties

print("Swifties v\(SWIFTIES_VERSION)\n")
print("Return evaluates completed forms,")
print("(reset) clears the stack and Ctrl+D quits.\n")

let env = Env()
env.begin()
let initPos = Pos("repl init")
try env.initCoreLib(pos: initPos)
try env.coreLib!.bind(pos: initPos)
try MathLib(env: env, pos: initPos).bind(pos: initPos)

let parser = Parser(env: env, source: "repl",
                    prefix: [spaceReader,
                             callReader,
                             intReader,
                             charReader,
                             stringReader,
                             stackReader,
                             quoteReader,
                             spliceReader,
                             idReader],
                    suffix: [pairReader])

var prompt = 1
var input = ""

while true {
    print("\(prompt)  ", terminator: "")
    let line = readLine(strippingNewline: false)
    if line == nil { break }
    
    do {
        try parser.slurp(line!)
    } catch {
        continue
    }
    
    let forms = parser.forms
    
    if parser.input.count == 0 {
        if forms.count > 0 {
            let startPc = env.pc
        
            do {
                for f in forms { try f.emit() }
                env.emit(STOP)
                try env.eval(startPc)
            } catch {
                print(error)
            }        
        }

        prompt += 1
        print(env.stack.dump())
        parser.reset()
    }
}
