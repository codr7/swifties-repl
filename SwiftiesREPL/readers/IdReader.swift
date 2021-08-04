import Foundation
import Swifties

public let idReader = IdReader()

func isSpace(_ c: Character) -> Bool {
    return c == " " || c == "\n" || c == "\t"
}

public class IdReader: Reader {
    public func readForm(_ input: inout String, root: Parser) throws -> Form? {
        var out: String = ""
        
        while let c = input.popLast() {
            if isSpace(c) || c == "(" || c == ")" {
                input.append(c)
                break
            }
            
            out.append(c)
            root.nextColumn()
        }
        
        return (out.count == 0) ? nil : IdForm(env: root.env, pos: root.pos, name: out)
    }
}
