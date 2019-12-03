//
//  TabBarNavigationUI.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import UIKit

internal protocol TabBarNavigationContext: Context, ModalContext, ForwardBackNavigationContext {}

/// A class that presents view controllers in a tab bar, and manages the navigation between them.
///
/// At the moment, this is achieved with a UINavigationController that can be pushed / popped to / from.
internal class TabBarNavigationUI<Token>: MadogMultiUIContainer<Token>, TabBarNavigationContext {
	private let tabBarController = UITabBarController()

	internal init() {
		super.init(viewController: tabBarController)
	}

	// MARK: - MadogMultiUIContext

	internal override func renderInitialViews(with tokens: [Token]) -> Bool {
		let viewControllers = tokens.compactMap { registry.createViewController(from: $0, context: self) }
			.map { UINavigationController(rootViewController: $0) }

		tabBarController.viewControllers = viewControllers
		return true
	}

	// MARK: - ModalContext

	func openModal(token: Any,
				   from fromViewController: UIViewController?,
				   presentationStyle: UIModalPresentationStyle?,
				   transitionStyle: UIModalTransitionStyle?,
				   popoverAnchor: Any?,
				   animated: Bool,
				   completion: (() -> Void)?) -> Bool {
		guard let token = token as? Token,
			let viewController = registry.createViewController(from: token, context: self) else {
			return false
		}

		let sourceViewController = fromViewController ?? tabBarController
		sourceViewController.madog_presentModally(viewController: viewController,
												  presentationStyle: presentationStyle,
												  transitionStyle: transitionStyle,
												  popoverAnchor: popoverAnchor,
												  animated: animated,
												  completion: completion)
		return true
	}

	// MARK: - ForwardBackNavigationContext

	internal func navigateForward(token: Any, animated: Bool) -> Bool {
		guard let token = token as? Token,
			let toViewController = registry.createViewController(from: token, context: self),
			let navigationController = tabBarController.selectedViewController as? UINavigationController else {
			return false
		}

		navigationController.pushViewController(toViewController, animated: animated)
		return true
	}

	internal func navigateBack(animated: Bool) -> Bool {
		guard let navigationController = tabBarController.selectedViewController as? UINavigationController else {
			return false
		}

		return navigationController.popViewController(animated: animated) != nil
	}

	internal func navigateBackToRoot(animated _: Bool) -> Bool {
		guard let navigationController = tabBarController.selectedViewController as? UINavigationController else {
			return false
		}

		return navigationController.popToRootViewController(animated: true) != nil
	}
}
