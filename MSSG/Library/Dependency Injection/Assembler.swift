//
//  Assembler.swift
//  Todo
//
//  Created by Max Rozdobudko on 6/9/18.
//  Copyright © 2018 Max Rozdobudko. All rights reserved.
//

import Foundation

class Context {
    static let assembler = DefaultAssembler()
}

protocol Assembler: MainAssembler, AuthAssembler, ContactsAssembler {

}

class DefaultAssembler: Assembler {

}

// MARK: - Injections

let mssg = MSSG()

extension MSSG {
    convenience init() {
        self.init(auth: Auth(), contacts: Contacts())
    }
}

extension Auth {
    convenience init() {
        self.init(service: Context.assembler.resolve())
    }
}

extension Contacts {
    convenience init() {
        self.init(service: Context.assembler.resolve())
    }
}

extension Current.User {
    convenience init() {
        self.init(service: Context.assembler.resolve())
    }
}

// MARK: View Model Injectctions

extension MainViewModel {
    convenience init() {
        self.init(mssg: mssg)
    }
}

extension ContactsViewModel {
    convenience init() {
        self.init(contacts: mssg.contacts)
    }
}
