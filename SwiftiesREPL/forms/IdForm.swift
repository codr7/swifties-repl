import Foundation
import Swifties

class IdForm: Swifties.IdForm {
    public var isDrop: Bool { name.allSatisfy({c in c == "d"}) }
    public var isRef: Bool { name.first == "&" }

    open override var slot: Slot? { isDrop ? nil : super.slot }

    open override func expand() throws -> Form { isDrop ? self : try super.expand() }
    
    open override func emit() throws {
        if isDrop {
            env.emit(Drop(env: env, pos: pos, pc: env.pc, count: name.count))
        } else if isRef {
            try emitRef(name: String(name.dropFirst()))
        } else {
            try super.emit()
        }
    }
}
