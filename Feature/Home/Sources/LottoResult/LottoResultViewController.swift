//
//  LottoResultViewController.swift
//  Home
//
//  Created by ttozzi on 8/17/25.
//

import Base
import DesignSystem
import SwiftRichString
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
  private lazy var resultStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 20
  }
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
    
    // TODO: 임시
    infoView.update(with: LottoResultInfoModel(roundText: "1181회", title: "1등 당첨!", desciprtion: "5,000원"))
    sattoMessageView.update(with: SattoMessageModel(title: "사또의 한마디...", message: "축하드리네!\n이번 행운의 주인공은 그대라네."))
    resultStackView.addArrangedSubview(makeWinningNumbersView())
    resultStackView.addArrangedSubview(makeResultView())
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
    
    view.addSubview(resultStackView)
    resultStackView.snp.makeConstraints { make in
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
    navigationBar.tintColor = STColors.white.color
  }
  
  private func setupBinding() {
    goToMainButton.tapPublisher
      .sink { [weak self] _ in
        self?.viewModel.send(input: .goToMainButtonTapped)
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
            self?.navigationBar.tintColor = STColors.black.color
          }
        }
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
  
  // TODO: 별도 뷰로 분리하기
  private func makeWinningNumbersView() -> UIView {
    let stackView = UIStackView().then {
      $0.axis = .horizontal
      $0.distribution = .equalSpacing
      $0.alignment = .center
      $0.isLayoutMarginsRelativeArrangement = true
      $0.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
      $0.backgroundColor = STColors.white.color
      $0.layer.cornerRadius = 30
      $0.clipsToBounds = true
    }
    
    let numbers = [4, 12, 18, 21, 24, 26] // TODO: 수정 필요
    let bonusNumber = 42
    
    numbers.forEach { number in
      let ball = Ball()
      ball.number = String(number)
      stackView.addArrangedSubview(ball)
      ball.snp.makeConstraints { make in
        make.size.equalTo(32)
      }
    }
    
    let plusView = UIImageView(image: STImages.resultPlus.image)
    plusView.snp.makeConstraints { make in
      make.size.equalTo(14)
    }
    stackView.addArrangedSubview(plusView)
    
    let bonusBall = Ball()
    bonusBall.number = String(bonusNumber)
    stackView.addArrangedSubview(bonusBall)
    
    stackView.snp.makeConstraints { make in
      make.height.equalTo(64)
    }
    return stackView
  }

  // TODO: 별도 뷰로 분리하기
  private func makeResultView() -> UIView {
    let stackView = UIStackView().then {
      $0.axis = .horizontal
      $0.distribution = .equalSpacing
      $0.alignment = .center
      $0.isLayoutMarginsRelativeArrangement = true
      $0.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
      $0.backgroundColor = STColors.white.color
      $0.layer.cornerRadius = 30
      $0.clipsToBounds = true
    }
    let rankView = UIView().then {
      $0.backgroundColor = STColors.primary2.color
      $0.layer.cornerRadius = 16
      $0.clipsToBounds = true
    }
    let rankLabel = UILabel().then {
      $0.style = Style {
        $0.font = DesignSystemFontFamily.Suit.extraBold.font(size: 12)
        $0.kerning = .point(0.18)
        $0.color = STColors.white.color
      }
      $0.styledText = "1등" // TODO: 수정 필요
    }
    rankView.addSubview(rankLabel)
    rankLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
    
    stackView.addArrangedSubview(rankView)
    rankView.snp.makeConstraints { make in
      make.size.equalTo(32)
    }
    
    let barView = UIImageView(image: STImages.resultBar.image)
    barView.snp.makeConstraints { make in
      make.size.equalTo(14)
    }
    stackView.addArrangedSubview(barView)
    
    let numbers = [4, 12, 18, 21, 24, 26] // TODO: 수정 필요
    let winningNumbers = [9, 11, 18, 21, 24, 33, 42]
    
    numbers.forEach { number in
      let ball = Ball()
      ball.number = String(number)
      ball.isColored = winningNumbers.contains(number)
      stackView.addArrangedSubview(ball)
      ball.snp.makeConstraints { make in
        make.size.equalTo(32)
      }
    }
    
    stackView.snp.makeConstraints { make in
      make.height.equalTo(64)
    }
    return stackView
  }
}
