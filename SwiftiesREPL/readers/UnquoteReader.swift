import Foundation
import Swifties

public func unquoteReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    
    if let c = p.getc() {
        if c == "," {
            p.nextColumn()
            
            if try p.readForm() {
                if let f = p.popForm() {
                    return UnquoteForm(env: p.env, pos: fpos, form: f)
                }
            }
        }
        
        p.ungetc(c)
    }

    return nil
}
