//
//  RuntimeResolver.swift
//  Madog
//
//  Created by Ceri Hughes on 23/11/2018.
//  Copyright © 2019 Ceri Hughes. All rights reserved.
//

import Foundation

/// An implementation of Resolver which uses objc-runtime magic to find all loaded classes that
/// subclass from ViewControllerProvider and ServiceProvider respectively.
public final class RuntimeResolver<T, C>: Resolver<T, C> {
    private let bundle: Bundle

    private var loadedViewControllerProviderCreationFunctions = [() -> ViewControllerProvider<T, C>]()
    private var loadedServiceProviderCreationFunctions = [(ServiceProviderCreationContext) -> ServiceProvider]()

    convenience override public init() {
        self.init(bundle: Bundle.main)
    }

    public init(bundle: Bundle) {
        self.bundle = bundle

        super.init()

        inspectLoadedClasses()
    }

    // MARK: Resolver

    public override func viewControllerProviderCreationFunctions() -> [() -> ViewControllerProvider<T, C>] {
        return loadedViewControllerProviderCreationFunctions
    }

    public override func serviceProviderCreationFunctions() -> [(ServiceProviderCreationContext) -> ServiceProvider] {
        return loadedServiceProviderCreationFunctions
    }

    // MARK: Private

    private func inspectLoadedClasses() {
        if let executablePath = bundle.executablePath {
            var classCount: UInt32 = 0
            let classNames = objc_copyClassNamesForImage(executablePath, &classCount)
            if let classNames = classNames {
                for i in 0 ..< classCount {
                    let className = classNames[Int(i)]
                    let name = String.init(cString: className)
                    print(name)
                    if let cls = NSClassFromString(name) as? ViewControllerProvider<T, C>.Type {
                        loadedViewControllerProviderCreationFunctions.append { return cls.init() }
                    }
                    if let cls = NSClassFromString(name) as? ServiceProvider.Type {
                        loadedServiceProviderCreationFunctions.append { context in
                            return cls.init(context: context)
                        }
                    }
                }
            }

            free(classNames);

            // Sort functions alphabetically by description
            loadedViewControllerProviderCreationFunctions.sort { String(describing: $0) < String(describing: $1) }
            loadedServiceProviderCreationFunctions.sort { String(describing: $0) < String(describing: $1) }
        }
    }
}
