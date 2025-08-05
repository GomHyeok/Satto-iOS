//
//  AppRouter.swift
//  CommonLayer
//
//  Created by 최재혁 on 7/23/25.
//

import Foundation
import UIKit

public enum AppRoute: Hashable {
  case fortune
  case history
  case home
  case onboarding(onboardingRoute: OnboardingRoute?)
  case setting

  public func hash(into hasher: inout Hasher) {
    switch self {
    case .fortune:
      hasher.combine(0)
    case .history:
      hasher.combine(1)
    case .home:
      hasher.combine(2)
    case .onboarding(let onboardingRoute):
      hasher.combine(3)
    case .setting:
      hasher.combine(4)
    }
  }

  public static func == (lhs: AppRoute, rhs: AppRoute) -> Bool {
    switch (lhs, rhs) {
    case (.fortune, .fortune), (.history, .history), (.home, .home), (.setting, .setting):
      return true
    case (.onboarding, .onboarding):
      return true
    default:
      return false
    }
  }
}

@MainActor
public protocol Routable: AnyObject {
  func navigate(to route: Any, how: NavigateType, with data: [String: Any])
}

public final class AppRouter: Routable {
  public static let shared = AppRouter()

  private var factories: [AppRoute: () -> Routable] = [:]

  private init() {}

  public func register(route: AppRoute, factory: @escaping () -> Routable) {
    factories[route] = factory
  }

  public func navigate(to route: Any, how: NavigateType, with data: [String: Any]) {
    guard let appRoute = route as? AppRoute else { return }
    guard let factory = factories[appRoute] else { return }
    let subRouter = factory()

    switch appRoute {
    case .fortune:
      break
    case .history:
      break
    case .home:
      break
    case .onboarding(let onboardingRoute):
      guard let onboardingRoute = onboardingRoute else { return }
      subRouter.navigate(to: onboardingRoute, how: how, with: data)
    case .setting:
      break
    }
  }
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
    case .push:
      if let navigationController = topViewController()?.navigationController {
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
