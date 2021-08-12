import Foundation
import Swifties

public let pairReader = PairReader()

public class PairReader: Reader {
    public func readForm(_ p: Parser) throws -> Form? {
        let c = p.getc()
        
        if c != ":" {
            if c != nil { p.ungetc(c!) }
            return nil
        }
        
        let fpos = p.pos
        p.nextColumn()
        let left = p.popForm()
        if left == nil { throw ReadError(p.pos, "Missing left value"); }
        if !(try p.readForm()) { throw ReadError(p.pos, "Missing right value")}
        let right = p.popForm()
        return PairForm(env: p.env, pos: fpos, (left!, right!))
    }
}
