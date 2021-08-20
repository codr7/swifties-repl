import Foundation
import Swifties

public func quoteReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    
    if let c = p.getc() {
        if c == "'" {
            if try p.readForm() {
                if let f = p.popForm() {
                    return LiteralForm(env: p.env, pos: fpos, f.quote())
                }
            }
        }
        
        p.ungetc(c)
    }

    return nil
}
