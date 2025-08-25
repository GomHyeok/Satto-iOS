//
//  LottoResultViewController.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Base
import DesignSystem
import UIKit

final class LottoResultViewController: BaseViewController {

  private let gradientLayer = CAGradientLayer().then {
    $0.colors = [
      STColors.primary7.color.cgColor,
      STColors.primary9.color.cgColor,
    ]
    $0.locations = [0, 0.75, 1]
    $0.startPoint = CGPoint(x: 0.5, y: 0)
    $0.endPoint = CGPoint(x: 0.5, y: 1)
  }
  private lazy var loadingView = LottoResultLoadingView()
  private lazy var infoView = LottoResultInfoView()
  private lazy var sattoMessageView = SattoMessageView()
  private lazy var resultNumberView = LottoResultNumberView()
  private lazy var goToMainButton = UIButton().then {
    $0.backgroundColor = STColors.primary2.color
    $0.layer.cornerRadius = 8
    let title = "메인으로 가기".set(style: Typography.Body_16_B.color(STColors.white.color))
    $0.setAttributedTitle(title, for: .normal)
    $0.setTitleColor(STColors.white.color, for: .normal)
  }
  private let viewModel: LottoResultViewModel

  public init(viewModel: LottoResultViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupNavigationBar()
    setupBinding()
    viewModel.send(input: .viewDidLoad)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    gradientLayer.frame = view.bounds
  }

  private func setupUI() {
    view.layer.insertSublayer(gradientLayer, at: .zero)

    view.addSubview(infoView)
    infoView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.horizontalEdges.equalToSuperview()
      make.height.equalTo(176)
    }

    view.addSubview(resultNumberView)
    resultNumberView.snp.makeConstraints { make in
      make.top.equalTo(infoView.snp.bottom)
      make.horizontalEdges.equalToSuperview().inset(24)
    }

    view.addSubview(sattoMessageView)
    sattoMessageView.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview().inset(24)
      make.height.equalTo(146)
    }

    view.addSubview(goToMainButton)
    goToMainButton.snp.makeConstraints { make in
      make.top.greaterThanOrEqualTo(sattoMessageView.snp.bottom).offset(54)
      make.height.equalTo(48)
      make.horizontalEdges.equalToSuperview().inset(24)
      make.bottom.equalTo(view.safeAreaLayoutGuide).inset(24)
    }

    view.addSubview(loadingView)
    loadingView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }

  private func setupNavigationBar() {
    title = "당첨 결과"
    navigationBar.backgroundColor = STColors.primary9.color
    let backButtonItem = NaivgationBarButtonItem.back
    backButtonItem.tapPublisher
      .sink { [weak self] in
        self?.viewModel.send(input: .backButtonTapped)
      }
      .store(in: &cancellables)
    setNavigationBarLeftButtonItems(items: [
      backButtonItem
    ])
    navigationBar.backgroundColor = .clear
    navigationBar.updateColor(STColors.white.color)
  }

  private func setupBinding() {
    goToMainButton.tapPublisher
      .sink { [weak self] _ in
        self?.viewModel.send(input: .goToMainButtonTapped)
      }
      .store(in: &cancellables)

    viewModel.output.updateResultInfo
      .compactMap(\.self)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] model in
        self?.infoView.update(with: model)
      }
      .store(in: &cancellables)

    viewModel.output.updateSattoMessage
      .compactMap(\.self)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] model in
        self?.sattoMessageView.update(with: model)
      }
      .store(in: &cancellables)

    viewModel.output.updateResultNumber
      .compactMap(\.self)
      .receive(on: DispatchQueue.main)
      .sink { [weak self] model in
        self?.resultNumberView.update(with: model)
      }
      .store(in: &cancellables)

    viewModel.output.isLoading
      .receive(on: DispatchQueue.main)
      .sink { [weak self] isLoading in
        if isLoading {
          self?.loadingView.alpha = 1
          self?.loadingView.play()
        } else {
          UIView.animate(withDuration: 0.25) {
            self?.loadingView.alpha = 0
            self?.navigationBar.updateColor(STColors.black.color)
          }
        }
      }
      .store(in: &cancellables)
    
    viewModel.output.showError
      .receive(on: DispatchQueue.main)
      .sink { [weak self] retryAction in
        guard let self else { return }
        self.showErrorPopup(action: retryAction)
      }
      .store(in: &cancellables)

    viewModel.output.back
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.navigationController?.popViewController(animated: true)
      }
      .store(in: &cancellables)

    viewModel.output.popToRoot
      .receive(on: DispatchQueue.main)
      .sink { [weak self] _ in
        // TODO: Router 에서 TabBar 의 root 화면(홈)으로 접근할 방법이 없음
        self?.navigationController?.popToRootViewController(animated: true)
      }
      .store(in: &cancellables)
  }
}
