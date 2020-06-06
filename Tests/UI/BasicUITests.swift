//
//  BasicUITests.swift
//  MadogTests
//
//  Created by Ceri Hughes on 05/06/2020.
//  Copyright © 2020 Ceri Hughes. All rights reserved.
//

#if canImport(KIF)

import KIF
import XCTest

@testable import Madog

class BasicUITests: MadogKIFTestCase {
    private var context: BasicUIContext!

    override func tearDown() {
        context = nil

        super.tearDown()
    }

    func testProtocolConformance() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNil(context as? ForwardBackNavigationContext)
        XCTAssertNil(context as? MultiContext)
    }

    func testRenderInitialUI() {
        context = renderUIAndAssert(token: "vc1")
        XCTAssertNotNil(context)
    }

    private func renderUIAndAssert(token: String) -> BasicUIContext? {
        let identifier = SingleUIIdentifier.createBasicIdentifier()
        let context = madog.renderUI(identifier: identifier, token: token, in: window)
        viewTester().usingLabel(token)?.waitForView()
        return context as? BasicUIContext
    }
}

#endif
