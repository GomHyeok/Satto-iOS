//
//  HomeRecommendationCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 7/31/25.
//

import Combine
import DesignSystem
import SnapKit
import UIKit

struct HomeRecommendationCollectionViewCellModel: HomeCellModel {

  enum State {
    case needsRecommendation
    case recommended(numbers: [Int])
    case needsResultCheck(numbers: [Int])
  }

  let dateText: String
  let title: String
  let state: State
}

final class HomeRecommendationCollectionViewCell: UICollectionViewCell {

  private enum Constant {
    static let seeMoreAreaHeight: CGFloat = 43
  }

  private lazy var contentStackView = UIStackView().then {
    $0.spacing = .zero
    $0.axis = .vertical
    $0.alignment = .center
  }
  private lazy var dateLabel = UILabel().then {
    $0.style = Typography.Caption_12_M
    $0.textColor = STColors.gray3.color
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_18_B
    $0.textColor = STColors.black.color
  }
  private lazy var numberBallContainerStackView = UIStackView().then {
    $0.spacing = 12
    $0.axis = .vertical
    $0.alignment = .center
  }
  private lazy var numberBallStackView = UIStackView().then {
    $0.spacing = 8
    $0.axis = .horizontal
  }
  private lazy var emptyMessageLabel = UILabel().then {
    $0.style = Typography.Body_14_R
    $0.textColor = STColors.gray5.color
    $0.styledText = "아직 받은 번호가 없어요"
  }
  private lazy var recommendButton = UIButton().then {
    $0.backgroundColor = STColors.primary2.color
    $0.layer.cornerRadius = 8
  }
  private lazy var seeMoreAreaView = UIView().then {
    $0.backgroundColor = .clear
  }
  private var seeMoreAreaViewHeight: Constraint?
  private var internalCancellables = Set<AnyCancellable>()
  private let buttonTapSubject = PassthroughSubject<Void, Never>()
  var butonTapPublisher: AnyPublisher<Void, Never> { buttonTapSubject.eraseToAnyPublisher() }
  var cancellables = Set<AnyCancellable>()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setupBinding()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    cancellables.removeAll()
  }

  private func setupUI() {
    contentView.backgroundColor = STColors.white.color
    contentView.layer.cornerRadius = 12
    contentView.clipsToBounds = true

    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(24)
      make.horizontalEdges.equalToSuperview().inset(20)
    }

    contentStackView.addArrangedSubview(dateLabel)
    dateLabel.snp.makeConstraints { make in
      make.height.equalTo(18)
    }
    contentStackView.setCustomSpacing(4, after: dateLabel)

    contentStackView.addArrangedSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.height.equalTo(27)
    }
    contentStackView.setCustomSpacing(20, after: titleLabel)

    contentStackView.addArrangedSubview(numberBallContainerStackView)
    numberBallContainerStackView.addArrangedSubview(numberBallStackView)
    numberBallContainerStackView.addArrangedSubview(emptyMessageLabel)
    contentStackView.setCustomSpacing(20, after: numberBallContainerStackView)

    contentStackView.addArrangedSubview(recommendButton)
    recommendButton.snp.makeConstraints { make in
      make.height.equalTo(48)
      make.horizontalEdges.equalToSuperview()
    }

    contentView.addSubview(seeMoreAreaView)
    seeMoreAreaView.snp.makeConstraints { make in
      make.top.equalTo(contentStackView.snp.bottom).offset(24)
      make.bottom.equalToSuperview()
      seeMoreAreaViewHeight = make.height.equalTo(Constant.seeMoreAreaHeight).constraint
      make.width.equalToSuperview()
    }

    let divider = UIView().then {
      $0.backgroundColor = STColors.gray8.color
    }
    seeMoreAreaView.addSubview(divider)
    divider.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.width.equalToSuperview()
      make.top.leading.trailing.equalToSuperview()
    }
    let seeMoreLabel = UILabel().then {
      $0.style = Typography.Caption_12_R
      $0.textColor = STColors.gray3.color
      $0.styledText = "자세히 보기"
    }
    seeMoreAreaView.addSubview(seeMoreLabel)
    seeMoreLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }

  private func setupBinding() {
    recommendButton.tapPublisher
      .sink { [weak self] in
        self?.buttonTapSubject.send(())
      }
      .store(in: &internalCancellables)
    seeMoreAreaView.gesturePublisher(gestureRecognizer: UITapGestureRecognizer())
      .sink { [weak self] _ in
        self?.buttonTapSubject.send(())
      }
      .store(in: &internalCancellables)
  }

  func update(with model: HomeRecommendationCollectionViewCellModel) {
    dateLabel.styledText = model.dateText
    titleLabel.styledText = model.title

    switch model.state {
    case .needsRecommendation:
      makeEmptyNumberBallStack()
      emptyMessageLabel.isHidden = false
      recommendButton.isHidden = false
      let style = Typography.Body_16_B.color(STColors.white.color)
      let styledText = "번호 추천받기".set(style: style)
      recommendButton.setAttributedTitle(styledText, for: .normal)
      seeMoreAreaView.isHidden = true
      seeMoreAreaViewHeight?.update(offset: 0)
    case .recommended(let numbers):
      makeNumberBallStack(for: numbers)
      emptyMessageLabel.isHidden = true
      recommendButton.isHidden = true
      seeMoreAreaView.isHidden = false
      seeMoreAreaViewHeight?.update(offset: Constant.seeMoreAreaHeight)
    case .needsResultCheck(let numbers):
      makeNumberBallStack(for: numbers)
      emptyMessageLabel.isHidden = true
      let style = Typography.Body_16_B.color(STColors.white.color)
      let styledText = "결과 확인하기".set(style: style)
      recommendButton.setAttributedTitle(styledText, for: .normal)
      recommendButton.isHidden = false
      seeMoreAreaView.isHidden = true
      seeMoreAreaViewHeight?.update(offset: 0)
    }
  }

  private func makeEmptyNumberBallStack() {
    numberBallStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    (1...6).forEach { _ in
      // TODO: 확인 필요
      let numberImageView = UIImageView(image: STImages.ball.image)
      numberImageView.contentMode = .scaleAspectFit
      numberBallStackView.addArrangedSubview(numberImageView)
    }
  }

  private func makeNumberBallStack(for numbers: [Int]) {
    numberBallStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    numbers.forEach { number in
      let ball = Ball()
      ball.number = String(number)
      numberBallStackView.addArrangedSubview(ball)
    }
  }
}

@available(iOS 17.0, *)
#Preview("번호 추천 X") {
  let cellModel = HomeRecommendationCollectionViewCellModel(
    dateText: "2025년 07월 17일 기준",
    title: "콩떡님을 위한 로또 번호 추천",
    state: .needsRecommendation
  )
  let cell = HomeRecommendationCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(250)
  }
  return cell
}

@available(iOS 17.0, *)
#Preview("번호 추천 O") {
  let cellModel = HomeRecommendationCollectionViewCellModel(
    dateText: "2025년 07월 17일 기준",
    title: "콩떡님을 위한 로또 번호 추천",
    state: .recommended(numbers: [9, 11, 18, 24, 26, 33])
  )
  let cell = HomeRecommendationCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(191)
  }
  return cell
}

@available(iOS 17.0, *)
#Preview("홈 - 번호 추천 O and 결과 오픈") {
  let cellModel = HomeRecommendationCollectionViewCellModel(
    dateText: "2025년 07월 17일 기준",
    title: "콩떡님을 위한 로또 번호 추천",
    state: .needsResultCheck(numbers: [9, 11, 18, 24, 26, 33])
  )
  let cell = HomeRecommendationCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(217)
  }
  return cell
}
