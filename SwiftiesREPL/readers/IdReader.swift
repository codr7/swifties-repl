import Foundation
import Swifties

public func _idReader() -> Reader {
    let r = Swifties.idReader("(", ")", "[", "]", ":", ".", "'", ",")
    
    return {p in
        if let f = try r(p) {
            return IdForm(env: f.env, pos: f.pos, name: (f as! Swifties.IdForm).name)
        }
        
        return nil
    }
}

public let idReader = _idReader()
