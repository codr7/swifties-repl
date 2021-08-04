import Foundation
import Swifties

public let callReader = CallReader()

public class CallReader: Reader {
    public func readForm(_ p: Parser) throws -> Form? {
        let fpos = p.pos
        var c = p.getc()
        
        if c != "(" {
            if c != nil { p.ungetc(c!) }
            return nil
        }
        
        p.nextColumn()
        let target = try p.readForm(p)
        if target == nil { throw ReadError(p.pos, "Missing target") }
        var args: [Form] = []

        while true {
            try spaceReader.readForm(p)
            c = p.getc()
            if c == nil || c == ")" { break }
            p.ungetc(c!)
            let f = try parser.readForm(p)
            if f == nil { break }
            args.append(f!)
        }

        if c != ")" { throw ReadError(p.pos, "Open call form: \((c == nil) ? "nil" : String(c!))") }
        p.nextColumn()
        return CallForm(env: p.env, pos: fpos, target: target!, args: args)
    }
}
