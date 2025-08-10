//
//  SplashViewcontroller.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/22/25.
//

import Combine
import DesignSystem
import Extension
import Foundation
import SnapKit
import Then
import UIKit

public final class SplashViewcontroller: UIViewController {
  private var store: [AnyCancellable] = []
  private let viewModel: SplashViewModel!
  private var router: OnboardingRouter!

  private lazy var splashImageView: UIImageView = UIImageView().then {
    $0.image = DesignSystemAsset.Images.sattoLogo.image
    $0.contentMode = .scaleAspectFit
  }

  private lazy var startButton: UIButton = UIButton().then {
    var style = Typography.Body_18_B
    style.color = DesignSystemAsset.Colors.white.color
    var styled = "시작하기".set(style: style)

    $0.setAttributedTitle(styled, for: .normal)
    $0.backgroundColor = DesignSystemAsset.Colors.primary2.color
    $0.layer.cornerRadius = 8
  }

  public init(viewModel: SplashViewModel, router: OnboardingRouter) {
    self.router = router
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .white
    setupBind()
    setupHierarchy()
    setupLayout()
  }
}

// MARK: Setup View
extension SplashViewcontroller {
  private func setupHierarchy() {
    self.view.addSubview(splashImageView)
    self.view.addSubview(startButton)
  }

  private func setupBind() {
    self.startButton.tapPublisher
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.viewModel.send(input: .startButtonTap)
      }
      .store(in: &store)

    self.viewModel.output.navigate
      .sink { [weak self] route in
        guard let self = self else { return }
        self.router.navigate(to: route, how: .push, with: [:])
      }
      .store(in: &store)
  }

  private func setupLayout() {
    splashImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(109)
      $0.top.equalToSuperview().offset(292.56)
      $0.trailing.equalToSuperview().offset(-109.67)
      $0.height.equalTo(44.08)
    }

    startButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(24.49)
      $0.trailing.equalToSuperview().offset(-23.51)
      $0.bottom.equalToSuperview().offset(-60)
      $0.height.equalTo(56)
    }
  }
}
