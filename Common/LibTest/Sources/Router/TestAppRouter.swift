//
//  TestAppRouter.swift
//  CommonLayer
//
//  Created by 최재혁 on 8/3/25.
//

import Foundation
import UIKit
import Lib

public enum TestAppRoute {
    case lib
    case subRoute
}

public protocol Routable : AnyObject {
    func navigate(to route: Any, how : NavigateType, with data: [String: Any])
}

public final class TestAppRouter: Routable {
    public static let shared = TestAppRouter()

    private var factories: [TestAppRoute: () -> Routable] = [:]

    private init() {}

    public func register(route: TestAppRoute, factory: @escaping () -> Routable) {
        factories[route] = factory
    }

    public func navigate(to route: Any, how : NavigateType, with data: [String: Any]) {
        guard let appRoute = route as? TestAppRoute else {
            print("Error: Invalid route type : \(type(of: route))")
            return
        }
        guard let factory = factories[appRoute] else {
            print("Error Invaild factory for route: \(appRoute). Please register the route first.")
            return
        }
        let subRouter = factory()
        
        switch appRoute {
        case .lib:
            subRouter.navigate(to: LibRoute.lib, how: how, with: data)
        case .subRoute:
            subRouter.navigate(to: SubRoute.sub, how: how, with: data)
        }
    }
}

extension Routable {
    func topViewController( from base: UIViewController? = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(from: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topViewController(from: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topViewController(from: presented)
        }
        return base
    }
}
