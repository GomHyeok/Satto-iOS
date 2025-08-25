//
//  BaseViewController.swift
//  Base
//
//  Created by ttozzi on 8/10/25.
//

import Combine
import DesignSystem
import SnapKit
import UIKit

open class BaseViewController: UIViewController {

  enum Constant {
    static let navigationBarHeight: CGFloat = 56
  }

  open var navigationBarStyle: NavigationBar.Style { .text(alignment: .center) }
  public private(set) lazy var navigationBar = NavigationBar(
    style: navigationBarStyle, height: Constant.navigationBarHeight)
  private lazy var interactionBlockerView = UIView().then {
    $0.backgroundColor = .clear
    $0.isHidden = true
    $0.isUserInteractionEnabled = true
  }
  private lazy var activityIndicator = UIActivityIndicatorView(style: .large).then {
    $0.hidesWhenStopped = true
  }

  private lazy var errorPopup = PopUp(style: .one).then {
    $0.isHidden = true
  }

  public override var title: String? {
    get { navigationBar.title }
    set { navigationBar.title = newValue }
  }
  private var navigationAreaHeight: Constraint?
  public var cancellables = Set<AnyCancellable>()
  private var errorPopupCancellables = Set<AnyCancellable>()

  open override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setNavigationBarHidden(false)

    view.addSubview(interactionBlockerView)
    interactionBlockerView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.trailing.bottom.equalToSuperview()
    }

    view.addSubview(activityIndicator)
    activityIndicator.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }

    view.addSubview(errorPopup)
    errorPopup.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(24)
    }
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    updateBottomSafeArea()
    view.bringSubviewToFront(navigationBar)
    if interactionBlockerView.isHidden == false {
      view.bringSubviewToFront(interactionBlockerView)
      view.bringSubviewToFront(activityIndicator)
    }
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
    navigationController?.interactivePopGestureRecognizer?.delegate = self
    view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints { make in
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

extension BaseViewController: UIGestureRecognizerDelegate {
  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
}

extension BaseViewController {
  public func showLoading() {
    interactionBlockerView.isHidden = false
    view.bringSubviewToFront(interactionBlockerView)
    view.bringSubviewToFront(activityIndicator)
    activityIndicator.startAnimating()
    view.bringSubviewToFront(navigationBar)
  }

  public func hideLoading() {
    interactionBlockerView.isHidden = true
    activityIndicator.stopAnimating()
  }
}

extension BaseViewController {
  public func showErrorPopup(action: @escaping () -> Void) {
    errorPopup.update(
      popUpModel: PopUpModel(
        title: "문제가 발생하였소", description: "잠시 후 다시 시도해 주시오.", actionButtonTitle: "확인",
        outButtonTitle: "취소"))
    errorPopup.update(style: .one)
    errorPopup.isHidden = false

    view.bringSubviewToFront(errorPopup)

    errorPopupCancellables.removeAll()

    errorPopup.actionButton.tapPublisher
      .sink { _ in
        action()
        self.errorPopup.isHidden = true
      }
      .store(in: &errorPopupCancellables)
  }
}
