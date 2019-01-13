//
//  ViewControllerProvider.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

/// A protocol that provides a VC (or a number of VCs) for a given token by registering with a ViewControllerRegistry.
public protocol ViewControllerProvider {
    func register(with registry: ViewControllerRegistry)
    func unregister(from registry: ViewControllerRegistry)
    func configure(with serviceProviders: [String : ServiceProvider])
}
