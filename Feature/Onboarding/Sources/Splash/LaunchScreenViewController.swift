//
//  LaunchScreenViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/26/25.
//

import DesignSystem
import Foundation
import SnapKit
import UIKit

public final class LaunchScreenViewController: UIViewController {

  public init() {
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = DesignSystemAsset.Colors.primary2.color
    setupHierarchy()
    setupLayout()
    moveToSplashView()
  }

  private lazy var launchImageView: UIImageView = UIImageView().then {
    $0.image = DesignSystemAsset.Images.sattoLogoWhite.image
    $0.contentMode = .scaleAspectFit
  }
}

extension LaunchScreenViewController {
  private func setupHierarchy() {
    self.view.addSubview(launchImageView)
  }

  private func setupLayout() {
    launchImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(109.67)
      $0.top.equalToSuperview().offset(383.65)
      $0.bottom.equalToSuperview().offset(-384.26)
      $0.trailing.equalToSuperview().offset(-109)
    }
  }

  private func moveToSplashView() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      let router = OnboardingRouter()
      let splashViewController = SplashViewcontroller(viewModel: SplashViewModel(), router: router)

      let navigationController = UINavigationController(rootViewController: splashViewController)

      if let window = UIApplication.shared.windows.first {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
      }
    }
  }
}
