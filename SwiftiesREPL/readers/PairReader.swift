import Foundation
import Swifties

public let pairReader = PairReader()

public class PairReader: Reader {
    public func readForm(_ p: Parser) throws -> Form? {
        let fpos = p.pos
        let c = p.getc()
        
        if c != ":" {
            if c != nil { p.ungetc(c!) }
            return nil
        }
        
        p.nextColumn()
        let left = p.popForm()
        if left == nil { throw ReadError(p.pos, "Missing left value"); }
        let right = try p.readForm()
        if right == nil { throw ReadError(p.pos, "Missing right value")}
        return PairForm(env: p.env, pos: fpos, (left!, right!))
    }
}
