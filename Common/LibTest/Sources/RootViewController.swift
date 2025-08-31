//
//  RootViewController.swift
//  CommonLayer
//
//  Created by 최재혁 on 8/3/25.
//

import Foundation
import Lib
import SnapKit
import Then
import UIKit

public final class RootViewController: UIViewController {

  // MARK: - UI Components

  // 어떤 화면으로 route 할 것인지 선택하는 버튼
  private lazy var toButton: UIButton = UIButton().then {
    $0.setTitle("이동할 화면 선택", for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .systemBlue
    $0.layer.cornerRadius = 10
    $0.addTarget(self, action: #selector(toButtonTapped), for: .touchUpInside)
  }

  // 어떻게 화면을 띄울 것인지 선택하는 버튼
  private lazy var howButton: UIButton = UIButton().then {
    $0.setTitle("네비게이션 방식 선택", for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .systemGreen
    $0.layer.cornerRadius = 10
    $0.addTarget(self, action: #selector(howButtonTapped), for: .touchUpInside)
  }

  //이동 버튼
  private lazy var moveButton: UIButton = UIButton().then {
    $0.setTitle("이동", for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    $0.setTitleColor(.white, for: .normal)
    $0.backgroundColor = .systemPink
    $0.layer.cornerRadius = 10
    $0.addTarget(self, action: #selector(moveButtonTapped), for: .touchUpInside)
  }

  // MARK: - Properties

  // 선택된 라우트와 네비게이션 방식을 저장할 변수
  private var selectedRoute: TestAppRoute?
  private var selectedPresentationStyle: NavigateType?

  // MARK: - View Lifecycle

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
  }

  // MARK: - Setup UI

  private func setupView() {
    view.backgroundColor = .white

    view.addSubview(toButton)
    view.addSubview(howButton)
    view.addSubview(moveButton)

    toButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(100)
      $0.leading.trailing.equalToSuperview().inset(50)
      $0.height.equalTo(50)
    }

    howButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(toButton.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(50)
      $0.height.equalTo(50)
    }

    moveButton.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(howButton.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(50)
      $0.height.equalTo(50)
    }
  }

  // MARK: - Button Actions

  @objc private func toButtonTapped() {
    showRouteSelectionAlert()
  }

  @objc private func howButtonTapped() {
    showPresentationSelectionAlert()
  }

  @objc private func moveButtonTapped() {
    TestAppRouter.shared.navigate(
      to: selectedRoute ?? .lib, how: selectedPresentationStyle ?? .push(), with: [:])
  }

  // MARK: - Alert Functions

  private func showRouteSelectionAlert() {
    let alert = UIAlertController(title: "이동할 화면 선택", message: nil, preferredStyle: .actionSheet)

    // 각 AppRoute에 대한 액션 추가
    alert.addAction(
      UIAlertAction(title: "lib", style: .default) { [weak self] _ in
        self?.selectedRoute = .lib
        self?.toButton.setTitle("Lib 화면으로", for: .normal)
      })
    alert.addAction(
      UIAlertAction(title: "subRoute", style: .default) { [weak self] _ in
        self?.selectedRoute = .subRoute
        self?.toButton.setTitle("subRoute 화면으로", for: .normal)
      })
    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    self.present(alert, animated: true, completion: nil)
  }

  private func showPresentationSelectionAlert() {
    let alert = UIAlertController(title: "네비게이션 방식 선택", message: nil, preferredStyle: .actionSheet)

    // 네비게이션 방식에 대한 액션 추가
    alert.addAction(
      UIAlertAction(title: "Push", style: .default) { [weak self] _ in
        self?.selectedPresentationStyle = .push()
        self?.howButton.setTitle("Push 방식으로", for: .normal)
      })
    alert.addAction(
      UIAlertAction(title: "Present", style: .default) { [weak self] _ in
        self?.selectedPresentationStyle = .present
        self?.howButton.setTitle("Present 방식으로", for: .normal)
      })
    alert.addAction(
      UIAlertAction(title: "Clear", style: .default) { [weak self] _ in
        self?.selectedPresentationStyle = .clear
        self?.howButton.setTitle("clear 방식으로", for: .normal)
      })
    alert.addAction(
      UIAlertAction(title: "currentContext", style: .default) { [weak self] _ in
        self?.selectedPresentationStyle = .currentContext
        self?.howButton.setTitle("currentContext 방식으로", for: .normal)
      })
    alert.addAction(
      UIAlertAction(title: "fullscreen", style: .default) { [weak self] _ in
        self?.selectedPresentationStyle = .fullscreen
        self?.howButton.setTitle("fullscreen 방식으로", for: .normal)
      })
    alert.addAction(
      UIAlertAction(title: "overCurrentContext", style: .default) { [weak self] _ in
        self?.selectedPresentationStyle = .overCurrentContext
        self?.howButton.setTitle("overCurrentContext 방식으로", for: .normal)
      })
    alert.addAction(
      UIAlertAction(title: "overFullScreen", style: .default) { [weak self] _ in
        self?.selectedPresentationStyle = .overFullScreen
        self?.howButton.setTitle("overFullScreen 방식으로", for: .normal)
      })

    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

    self.present(alert, animated: true, completion: nil)
  }

  // MARK: - Navigation Logic
}

// 네비게이션 방식을 나타내는 enum (CommonLayer 내부에 정의)
public enum PresentationStyle {
  case push
  case present
}
