//
//  BaseNavigationController.swift
//  Base
//
//  Created by ttozzi on 8/17/25.
//

import UIKit

public final class BaseNavigationController: UINavigationController {

  public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
    if viewController.hidesBottomBarWhenPushed {
      (tabBarController as? BaseTabBarController)?.setTabBarHidden(true, animated: false)
    }
    super.pushViewController(viewController, animated: animated)
  }

  @discardableResult
  public override func popViewController(animated: Bool) -> UIViewController? {
    let popped = super.popViewController(animated: animated)
    let top = topViewController
    let shouldHideTabBar = top?.hidesBottomBarWhenPushed ?? false
    (tabBarController as? BaseTabBarController)?.setTabBarHidden(shouldHideTabBar, animated: false)
    return popped
  }

  public override func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]? {
    let poppedControllers = super.popToViewController(viewController, animated: animated)
    (tabBarController as? BaseTabBarController)?.setTabBarHidden(viewController.hidesBottomBarWhenPushed, animated: false)
    return poppedControllers
  }

  public override func popToRootViewController(animated: Bool) -> [UIViewController]? {
    let poppedControllers = super.popToRootViewController(animated: animated)
    let shouldHideTabBar = viewControllers.first?.hidesBottomBarWhenPushed ?? false
    (tabBarController as? BaseTabBarController)?.setTabBarHidden(shouldHideTabBar, animated: false)
    return poppedControllers
  }
}
