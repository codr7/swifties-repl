import Foundation
import Swifties

public let stackReader = StackReader()

public class StackReader: Reader {
    public func readForm(_ p: Parser) throws -> Form? {
        let fpos = p.pos
        var c = p.getc()
        
        if c != "[" {
            if c != nil { p.ungetc(c!) }
            return nil
        }
        
        p.nextColumn()
        var items: [Form] = []

        while true {
            try spaceReader.readForm(p)
            c = p.getc()
            if c == nil || c == "]" { break }
            p.ungetc(c!)
            let f = try parser.readForm()
            if f == nil { break }
            items.append(f!)
        }

        if c != "]" { throw ReadError(p.pos, "Open stack form: \((c == nil) ? "nil" : String(c!))") }
        p.nextColumn()
        return StackForm(env: p.env, pos: fpos, items: items)
    }
}
