//
//  NavigationContexts.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol Context: class {
    func change<VC: UIViewController>(to uiIdentifier: SingleUIIdentifier<VC>, with token: Any) -> Bool
    func change<VC: UIViewController>(to uiIdentifier: MultiUIIdentifier<VC>, with tokens: [Any]) -> Bool
}

public protocol ModalContext: class {
    func openModal(with token: Any, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol ForwardBackNavigationContext: class {
    func navigateForward(with token: Any, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
    func navigateBackToRoot(animated: Bool) -> Bool
}
