//
//  AppDelegate.swift
//  MadogSample
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Madog
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let window = UIWindow()
    let madog = Madog<ResourceLocator>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        madog.resolve(resolver: RuntimeResolver(), launchOptions: launchOptions)
        let result = madog.addSingleUICreationFunction(identifier: splitViewControllerIdentifier) { return SplitUI() }
        guard result == true else {
            return false
        }

        window.makeKeyAndVisible()

        let initialRL = ResourceLocator.loginResourceLocator
        let identifier = SingleUIIdentifier.createSplitViewControllerIdentifier { (splitController) in
            splitController.preferredDisplayMode = .allVisible
            splitController.presentsWithGesture = false
        }
        return madog.renderSingleUI(identifier, with: initialRL, in: window)
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        guard let currentContext = madog.currentContext else {
            return false
        }

        let token = ResourceLocator.createVC2ResourceLocator(stringData: String(url.absoluteString.count))
        if let navigationContext = currentContext as? ForwardBackNavigationContext {
            return navigationContext.navigateForward(with: token, animated: true) != nil
        } else {
            let identifier = SingleUIIdentifier.createNavigationControllerIdentifier()
            return currentContext.change(to: identifier, with: token)
        }
    }
}

let splitViewControllerIdentifier = "splitViewControllerIdentifier"

extension SingleUIIdentifier {
    public static func createSplitViewControllerIdentifier(customisation: @escaping (UISplitViewController) -> Void = { _ in }) -> SingleUIIdentifier<UISplitViewController> {
        return SingleUIIdentifier<UISplitViewController>(splitViewControllerIdentifier, customisation: customisation)
    }
}
