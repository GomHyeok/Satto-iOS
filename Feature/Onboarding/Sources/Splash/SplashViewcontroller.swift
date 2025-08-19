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
    $0.image = STImages.loginLogo.image
    $0.contentMode = .scaleAspectFill
  }

  private lazy var splashTitle = UILabel().then {
    $0.style = Typography.Display_28_B
    $0.textColor = STColors.primary2.color
    $0.styledText = "복을 가득 담아\n보내드리네"
    $0.textAlignment = .left
    $0.numberOfLines = 2
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
    self.view.addSubview(splashTitle)
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
        self.router.navigate(to: route, how: .push(), with: [:])
      }
      .store(in: &store)
  }

  private func setupLayout() {
    splashImageView.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(40)
      make.top.equalToSuperview().offset(110)
      make.height.equalTo(50)
    }

    splashTitle.snp.makeConstraints { make in
      make.top.equalTo(splashImageView.snp.bottom).offset(24)
      make.leading.trailing.equalToSuperview().inset(40)
    }

    startButton.snp.makeConstraints { make in
      make.leading.trailing.equalToSuperview().inset(24)
      make.bottom.equalToSuperview().offset(-60)
      make.height.equalTo(56)
    }
  }
}
