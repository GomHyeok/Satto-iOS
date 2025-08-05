//
//  LibRouter.swift
//  CommonLayer
//
//  Created by 최재혁 on 8/3/25.
//

import Foundation
import UIKit
import Lib

public enum LibRoute {
    case lib
}

public final class LibRouter : Routable {
    private var factories: [LibRoute: () -> UIViewController]

    public init(factories: [LibRoute : () -> UIViewController]) {
        self.factories = factories
    }
    
    public func navigate(to route: Any, how: NavigateType, with data: [String : Any]) {
        guard let libRoute = route as? LibRoute else { return }
        guard let factory = factories[libRoute] else { return }
        let viewController = factory()
        
        guard let topViewController = topViewController() else { return }
        
        switch how {
        case .push:
            topViewController.navigationController?.pushViewController(viewController, animated: true)
        case .present:
            topViewController.present(viewController, animated: true, completion: nil)
        case .fullscreen:
            viewController.modalPresentationStyle = .fullScreen
            topViewController.present(viewController, animated: true, completion: nil)
        case .currentContext:
            viewController.modalPresentationStyle = .currentContext
            topViewController.present(viewController, animated: true, completion: nil)
        case .overFullScreen:
            viewController.modalPresentationStyle = .overFullScreen
            topViewController.present(viewController, animated: true, completion: nil)
        case .overCurrentContext:
            viewController.modalPresentationStyle = .overCurrentContext
            topViewController.present(viewController, animated: true, completion: nil)
        case .custom:
            viewController.modalPresentationStyle = .custom
            topViewController.present(viewController, animated: true, completion: nil)
        case .clear:
            if let navigationController = topViewController.navigationController {
                navigationController.viewControllers.removeAll()
                navigationController.pushViewController(viewController, animated: true)
            } else {
                topViewController.dismiss(animated: true, completion: nil)
            }
        }
    }
}
