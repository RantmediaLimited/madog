//
//  MadogUIContainer.swift
//  Madog
//
//  Created by Ceri Hughes on 07/12/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol MadogUIContainerDelegate: AnyObject {
    func createUI<VC: UIViewController>(identifier: MadogUIIdentifier<VC>,
                                        tokenHolder: TokenHolder<Any>,
                                        isModal: Bool,
                                        customisation: CustomisationBlock<VC>?) -> MadogUIContainer?

    func releaseContext(for viewController: UIViewController)
}

open class MadogUIContainer: Context {
    internal weak var delegate: MadogUIContainerDelegate?
    internal let viewController: UIViewController

    public init(viewController: UIViewController) {
        self.viewController = viewController
    }

    // MARK: - Context

    public func close(animated: Bool, completion: (() -> Void)?) -> Bool {
        // OVERRIDE
        false
    }

    public func change<VC: UIViewController>(to identifier: MadogUIIdentifier<VC>,
                                             tokenHolder: TokenHolder<Any>,
                                             transition: Transition?,
                                             customisation: CustomisationBlock<VC>?) -> Context? {
        guard let delegate = delegate,
            let window = viewController.view.window,
            let container = delegate.createUI(identifier: identifier,
                                              tokenHolder: tokenHolder,
                                              isModal: false,
                                              customisation: customisation) else {
            return nil
        }

        window.setRootViewController(container.viewController, transition: transition)
        return container
    }
}
