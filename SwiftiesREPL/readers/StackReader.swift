import Foundation
import Swifties

public func stackReader(_ p: Parser) throws -> Form? {
    let fpos = p.pos
    var c = p.getc()
        
    if c != "[" {
        if c != nil { p.ungetc(c!) }
        return nil
    }
        
    p.nextColumn()
    var items: [Form] = []

    while true {
        try spaceReader(p)
        c = p.getc()
        if c == nil || c == "]" { break }
        p.ungetc(c!)
        if !(try parser.readForm()) { break }
        items.append(parser.popForm()!)
    }

    if c != "]" { throw ReadError(p.pos, "Open stack form: \((c == nil) ? "nil" : String(c!))") }
    p.nextColumn()
    
    return StackForm(env: p.env, pos: fpos, items: items)
}
