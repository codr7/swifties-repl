import Foundation
import Swifties

public let idReader = IdReader()

public class IdReader: Reader {
    public func readForm(_ p: Parser) throws -> Form? {
        let fpos = p.pos
        var out: String = ""
        
        while let c = p.getc() {
            if c.isWhitespace || c == "(" || c == ")" {
                p.ungetc(c)
                break
            }
            
            out.append(c)
            p.nextColumn()
        }
        
        return (out.count == 0) ? nil : IdForm(env: p.env, pos: fpos, name: out)
    }
}
