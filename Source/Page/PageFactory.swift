//
//  PageFactory.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

protocol PageFactory {
    static func createPage() -> Page
}
