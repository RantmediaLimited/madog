//
//  State1.swift
//  Madog
//
//  Created by Ceri Hughes on 24/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation
import Madog

let state1Name = "state1Name"

class State1: StateFactory, State {

    // MARK: StateFactory

    static func createState() -> State {
        return State1()
    }

    // MARK: State

    let name = state1Name

    let somethingShared = "This is shared state"
}
