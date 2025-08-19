//
//  LaunchScreenViewController.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/26/25.
//

import Base
import DesignSystem
import Foundation
import Lib
import SnapKit
import UIKit

public final class LaunchScreenViewController: BaseViewController {

  private let viewModel: LaunchScreenViewModel

  public init(viewModel: LaunchScreenViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = STColors.primary2.color
    setupHierarchy()
    setupLayout()
    setupBinding()
    viewModel.send(input: .viewDidLoad)
  }

  private lazy var launchImageView: UIImageView = UIImageView().then {
    $0.image = STImages.launchLogo.image
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

  private func setupBinding() {
    viewModel.output.moveToSplash
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.moveToSplashView()
      }
      .store(in: &cancellables)
  }

  private func moveToSplashView() {
    let router = OnboardingRouter()
    let splashViewController = SplashViewcontroller(viewModel: SplashViewModel(), router: router)

    let navigationController = UINavigationController(rootViewController: splashViewController)

    if let window = UIApplication.shared.windows.first {
      window.rootViewController = navigationController
      window.makeKeyAndVisible()
    }
  }
}
