//
//  NavigationContexts.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import UIKit

public protocol Context {
    func change<VC: UIViewController>(to uiIdentifier: SinglePageUIIdentifier<VC>, with token: Any) -> Bool
    func change<VC: UIViewController>(to uiIdentifier: MultiPageUIIdentifier<VC>, with tokens: [Any]) -> Bool
}

public protocol ModalContext {
    func openModal(with token: Any, from fromViewController: UIViewController, animated: Bool) -> NavigationToken?
}

public protocol ForwardBackNavigationContext {
    func navigateForward(with token: Any, animated: Bool) -> NavigationToken?
    func navigateBack(animated: Bool) -> Bool
}
