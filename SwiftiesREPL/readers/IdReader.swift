import Foundation
import Swifties

public let idReader = IdReader()

public class IdReader: Reader {
    public func readForm(_ p: Parser) throws -> Form? {
        var out: String = ""
        
        while let c = p.getc() {
            if isSpace(c) || c == "(" || c == ")" {
                if out.count > 0 { p.ungetc(c) }
                break
            }
            
            out.append(c)
            p.nextColumn()
        }
        
        return (out.count == 0) ? nil : IdForm(env: p.env, pos: p.pos, name: out)
    }
}

func isSpace(_ c: Character) -> Bool { c == " " || c == "\n" || c == "\t" }
