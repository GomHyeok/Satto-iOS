//
//  AppRouter.swift
//  CommonLayer
//
//  Created by 최재혁 on 7/23/25.
//

import Foundation
import UIKit

@MainActor
public protocol Routable: AnyObject {
  func navigate(to route: Any, how: NavigateType, with data: [String: Any])
  func setFactories()
}

extension Routable {
  public func topViewController(
    from base: UIViewController? = UIApplication.shared.connectedScenes
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

  public func manageViewController(_ viewController: UIViewController, how: NavigateType) {
    switch how {
    case .push(let hidesBottomBarWhenPushed):
      if let navigationController = topViewController()?.navigationController {
        viewController.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
        navigationController.pushViewController(viewController, animated: true)
      }
    case .present:
      topViewController()?.present(viewController, animated: true, completion: nil)
    case .fullscreen:
      viewController.modalPresentationStyle = .fullScreen
      topViewController()?.present(viewController, animated: true, completion: nil)
    case .currentContext:
      viewController.modalPresentationStyle = .currentContext
      topViewController()?.present(viewController, animated: true, completion: nil)
    case .overFullScreen:
      viewController.modalPresentationStyle = .overFullScreen
      topViewController()?.present(viewController, animated: true, completion: nil)
    case .overCurrentContext:
      viewController.modalPresentationStyle = .overCurrentContext
      topViewController()?.present(viewController, animated: true, completion: nil)
    case .custom:
      viewController.modalPresentationStyle = .custom
      topViewController()?.present(viewController, animated: true, completion: nil)
    case .clear:
      if let navigationController = topViewController()?.navigationController {
        navigationController.viewControllers.removeAll()
        navigationController.pushViewController(viewController, animated: true)
      } else {
        topViewController()?.dismiss(animated: true, completion: nil)
      }
    }
  }
}
