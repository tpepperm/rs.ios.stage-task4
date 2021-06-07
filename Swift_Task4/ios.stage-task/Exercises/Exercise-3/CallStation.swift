import Foundation

final class CallStation {

    var allUsers: [User] = []
    var allCalls: [Call] = []
}

extension CallStation: Station {
    
    func users() -> [User] {
        return allUsers
    }
    
    func add(user: User) {
        if !allUsers.contains(user) {
            allUsers.append(user)
        }
    }
    
    func remove(user: User) {
        if let index = allUsers.firstIndex(where: { $0.id == user.id }) {
            allUsers.remove(at: index)
        }
    }
    
    func execute(action: CallAction) -> CallID? {
        var callId: UUID?

        switch action {
        case .start(from: let from, to: let to):
            guard allUsers.contains(from) || allUsers.contains(to) else { return nil }

            let call: Call
            if !allUsers.contains(from) || !allUsers.contains(to) {
                call = Call(id: from.id, incomingUser: from, outgoingUser: to, status: .ended(reason: .error))
            } else if currentCall(user: to) != nil {
                call = Call(id: from.id, incomingUser: from, outgoingUser: to, status: .ended(reason: .userBusy))
            } else {
                call = Call(id: from.id, incomingUser: from, outgoingUser: to, status: .calling)
            }
            allCalls.insert(call, at: 0)
            callId = call.id
        case .answer(from: let from):
            guard let index = allCalls.firstIndex(where: { $0.outgoingUser == from }) else { return nil }

            let call = allCalls[index]
            callId = call.id
            if !allUsers.contains(call.incomingUser) || !allUsers.contains(call.outgoingUser) {
                let newCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .error))
                allCalls[index] = newCall
                return nil
            } else {
                let newCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .talk)
                allCalls[index] = newCall
            }
        case .end(from: let from):
            if let index = allCalls.firstIndex(where: { $0.outgoingUser == from || $0.incomingUser == from }) {
                let call = allCalls[index]
                callId = call.id
                switch call.status {
                case .calling:
                    if call.outgoingUser == from {
                        let newCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .cancel))
                        allCalls[index] = newCall
                    } else if call.incomingUser == from {
                        let newCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .end))
                        allCalls[index] = newCall
                    }
                case .talk:
                    let newCall = Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: .ended(reason: .end))
                    allCalls[index] = newCall
                case .ended:
                    break
                }
            }
        }
        return callId
    }
    
    func calls() -> [Call] {
        return allCalls
    }
    
    func calls(user: User) -> [Call] {
        return allCalls.filter { $0.incomingUser == user || $0.outgoingUser == user }
    }
    
    func call(id: CallID) -> Call? {
        return allCalls.first { $0.id == id }
    }
    
    func currentCall(user: User) -> Call? {
        return allCalls.first(where: { ($0.incomingUser == user || $0.outgoingUser == user) && ($0.status == .calling || $0.status == .talk) })
    }
}
