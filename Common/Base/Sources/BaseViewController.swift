//
//  BaseViewController.swift
//  Base
//
//  Created by ttozzi on 8/10/25.
//

import Combine
import SnapKit
import UIKit

open class BaseViewController: UIViewController {

  enum Constant {
    static let navigationBarHeight: CGFloat = 56
  }

  open var navigationBarStyle: NavigationBar.Style { .text(alignment: .center) }
  public private(set) lazy var navigationBar = NavigationBar(
    style: navigationBarStyle, height: Constant.navigationBarHeight)
  public override var title: String? {
    get { navigationBar.title }
    set { navigationBar.title = newValue }
  }
  private var navigationAreaHeight: Constraint?
  public var cancellables = Set<AnyCancellable>()

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setNavigationBarHidden(false)
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateBottomSafeArea()
  }

  public func setNavigationBarHidden(_ isHidden: Bool) {
    navigationBar.isHidden = isHidden
    additionalSafeAreaInsets.top = isHidden ? .zero : Constant.navigationBarHeight
  }

  public func setNavigationBarLeftButtonItems(items: [any NavigationBarItem]) {
    navigationBar.setLeftButtonItems(items)
  }

  public func setNavigationBarRightButtonItems(items: [any NavigationBarItem]) {
    navigationBar.setRightButtonItems(items)
  }

  private func setupNavigationBar() {
    navigationController?.setNavigationBarHidden(true, animated: false)
    view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.horizontalEdges.equalToSuperview()
    }
  }

  private func updateBottomSafeArea() {
    guard let tabBarController = tabBarController as? BaseTabBarController,
      tabBarController.customTabBar.isHidden == false
    else {
      additionalSafeAreaInsets.bottom = .zero
      return
    }
    additionalSafeAreaInsets.bottom = TabBarView.Constant.tabBarHeight
  }
}
