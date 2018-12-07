//
//  WeakContextFactory.swift
//  MadogSample
//
//  Created by Ceri Hughes on 02/12/2018.
//  Copyright © 2018 Ceri Hughes. All rights reserved.
//

import Foundation

typealias WeakContextCreationFunction = (Context) -> Context?

class WeakContextFactory {
    private var weakContextCreationFunctions = [WeakContextCreationFunction]()

    init() {
        weakContextCreationFunctions.append { (context) -> Context? in
            if let context = context as? NavigationContext {
                return WeakNavigationContext(context)
            }
            return nil
        }

        weakContextCreationFunctions.append { (context) -> Context? in
            if let context = context as? TabBarNavigationContext {
                return WeakTabBarNavigationContext(context)
            }
            return nil
        }
    }

    func createWeakContext(for context: Context) -> Context? {
        return weakContextCreationFunctions.compactMap { $0(context) }.first
    }
}

class WeakNavigationContext: NavigationContext {
    weak var target: NavigationContext?

    init(_ target: NavigationContext) {
        self.target = target
    }

    // MARK: - Context

    func change<Token>(to uiIdentifier: SinglePageUIIdentifier, with token: Token) -> Bool {
        return target?.change(to: uiIdentifier, with: token) ?? false
    }

    func change<Token>(to uiIdentifier: MultiPageUIIdentifier, with tokens: [Token]) -> Bool {
        return target?.change(to: uiIdentifier, with: tokens) ?? false
    }

    func openModal<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return target?.openModal(with: token, from: fromViewController, animated: animated)
    }

    // MARK: - SinglePageContext

    func renderInitialView<Token>(with token: Token) -> Bool {
        return target?.renderInitialView(with: token) ?? false
    }

    // MARK: - ForwardBackNavigationContext

    func navigateForward<Token>(with token: Token, animated: Bool) -> NavigationToken? {
        return target?.navigateForward(with: token, animated: animated)
    }

    func navigateBack(animated: Bool) -> Bool {
        return target?.navigateBack(animated: animated) ?? false
    }
}

class WeakTabBarNavigationContext: TabBarNavigationContext {
    weak var target: TabBarNavigationContext?

    init(_ target: TabBarNavigationContext) {
        self.target = target
    }

    // MARK: - Context

    func change<Token>(to uiIdentifier: SinglePageUIIdentifier, with token: Token) -> Bool {
        return target?.change(to: uiIdentifier, with: token) ?? false
    }

    func change<Token>(to uiIdentifier: MultiPageUIIdentifier, with tokens: [Token]) -> Bool {
        return target?.change(to: uiIdentifier, with: tokens) ?? false
    }

    func openModal<Token>(with token: Token, from fromViewController: UIViewController, animated: Bool) -> NavigationToken? {
        return target?.openModal(with: token, from: fromViewController, animated: animated)
    }

    // MARK: - MultiPageContext

    func renderInitialViews<Token>(with tokens: [Token]) -> Bool {
        return target?.renderInitialViews(with: tokens) ?? false
    }

    // MARK: - ForwardBackNavigationContext

    func navigateForward<Token>(with token: Token, animated: Bool) -> NavigationToken? {
        return target?.navigateForward(with: token, animated: animated)
    }

    func navigateBack(animated: Bool) -> Bool {
        return target?.navigateBack(animated: animated) ?? false
    }
}