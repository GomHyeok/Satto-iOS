//
//  SubRouter.swift
//  CommonLayer
//
//  Created by 최재혁 on 8/3/25.
//

import Foundation
import Lib
import UIKit

public enum SubRoute {
  case sub
}

public final class SubRouter: Routable {
  private var factories: [SubRoute: () -> UIViewController]

  public init(factories: [SubRoute: () -> UIViewController]) {
    self.factories = factories
  }

  public func navigate(to route: Any, how: NavigateType, with data: [String: Any]) {
    guard let subRoute = route as? SubRoute else { return }
    guard let factory = factories[subRoute] else { return }
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
    case .pop:
      if let navigationController = topViewController.navigationController {
        navigationController.popViewController(animated: true)
      } else {
        topViewController.dismiss(animated: true, completion: nil)
      }
    }
  }
}
