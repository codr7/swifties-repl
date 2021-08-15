import Foundation
import Swifties

public func idReader (_ p: Parser) throws -> Form? {
    let fpos = p.pos
    var out = ""
        
    while let c = p.getc() {
        if c.isWhitespace || c == "(" || c == ")" || c == "[" || c == "]" || c == ":" {
            p.ungetc(c)
            break
        }
            
        out.append(c)
        p.nextColumn()
    }
        
    return (out.count == 0) ? nil : IdForm(env: p.env, pos: fpos, name: out)
}
