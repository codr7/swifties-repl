import Foundation
import Swifties

func isSpace(_ c: Character) -> Bool {
    return c == " " || c == "\n" || c == "\t"
}

public let idReader = IdReader()

public class IdReader: Reader {
    public func readForm(_ input: inout String, root: Parser) throws -> Form? {
        var out: String = ""
        
        while let c = input.popLast() {
            if isSpace(c) || c == "(" || c == ")" {
                input.append(c)
                break
            }
            
            out.append(c)
            root.pos.next()
        }
        
        return out.count == 0 ? nil : IdForm(env: root.env, pos: root.pos, name: out)
    }
}
