//
//  NumberRecommendationCollectionViewCell.swift
//  Home
//
//  Created by ttozzi on 8/7/25.
//

import DesignSystem
import Extension
import UIKit

struct NumberRecommendationCollectionViewCellModel: RecommendationDetailCellModel {
  let roundText: String
  let title: String
  let numbers: [Int]
  let expectedPrize: String
  let timeUntilDraw: String  // TODO: 확인 필요
}

final class NumberRecommendationCollectionViewCell: UICollectionViewCell {

  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 16
    $0.axis = .vertical
    $0.alignment = .center
  }
  private lazy var roundTextChip = PaddingLabel().then {  // TODO: Chip Component
    $0.layer.borderColor = STColors.primary7.color.cgColor
    $0.layer.borderWidth = 1
    $0.layer.cornerRadius = 6
    $0.clipsToBounds = true
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.primary2.color
    $0.textAlignment = .center
    $0.contentInsets = UIEdgeInsets(top: 3.5, left: 10, bottom: 3.5, right: 10)
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_18_B
    $0.textColor = STColors.black.color
  }
  private lazy var numberBallStackView = UIStackView().then {
    $0.spacing = 12
    $0.axis = .horizontal
    $0.alignment = .center
  }
  private lazy var expectedPrizeLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.gray1.color
    $0.textAlignment = .right
  }
  private lazy var timeUntilDrawLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.gray1.color
    $0.textAlignment = .right
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    contentView.backgroundColor = STColors.white.color
    contentView.layer.cornerRadius = 12
    contentView.clipsToBounds = true

    contentView.addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(24)
      make.leading.trailing.bottom.equalToSuperview().inset(20)
    }

    contentStackView.addArrangedSubview(roundTextChip)
    roundTextChip.snp.makeConstraints { make in
      make.height.equalTo(28)
    }

    contentStackView.addArrangedSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.height.equalTo(27)
    }

    contentStackView.addArrangedSubview(numberBallStackView)
    numberBallStackView.snp.makeConstraints { make in
      make.height.equalTo(40)
    }

    let line = DashedLineView(color: STColors.gray6.color)
    contentStackView.addArrangedSubview(line)
    line.snp.makeConstraints { make in
      make.height.equalTo(1)
      make.width.equalToSuperview()
    }

    let expectedPrizeStackView = makeTextStackView(
      title: "이번 주 예상 당첨금", descriptionLabel: expectedPrizeLabel)
    contentStackView.addArrangedSubview(expectedPrizeStackView)
    expectedPrizeStackView.snp.makeConstraints { make in
      make.width.equalToSuperview()
    }
    contentStackView.setCustomSpacing(6, after: expectedPrizeStackView)
    let timeUntilDrawStackView = makeTextStackView(
      title: "추첨까지 남은 시간", descriptionLabel: timeUntilDrawLabel)
    contentStackView.addArrangedSubview(timeUntilDrawStackView)
    timeUntilDrawStackView.snp.makeConstraints { make in
      make.width.equalToSuperview()
    }
  }

  func update(with model: NumberRecommendationCollectionViewCellModel) {
    roundTextChip.styledText = model.roundText
    titleLabel.styledText = model.title
    numberBallStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    model.numbers.forEach { number in
      let ball = Ball()
      ball.number = String(number)
      numberBallStackView.addArrangedSubview(ball)
    }
    expectedPrizeLabel.styledText = model.expectedPrize
    timeUntilDrawLabel.styledText = model.timeUntilDraw
  }

  private func makeTextStackView(title: String, descriptionLabel: UILabel) -> UIStackView {
    let textStackView = UIStackView().then {
      $0.axis = .horizontal
      $0.alignment = .fill
      $0.distribution = .fill
    }
    textStackView.snp.makeConstraints { make in
      make.height.equalTo(21)
    }
    let titleLabel = UILabel().then {
      $0.style = Typography.Body_14_M
      $0.textColor = STColors.gray3.color
      $0.setContentHuggingPriority(.required, for: .horizontal)
    }
    titleLabel.styledText = title
    textStackView.addArrangedSubview(titleLabel)
    textStackView.addArrangedSubview(descriptionLabel)
    return textStackView
  }
}

@available(iOS 17.0, *)
#Preview {
  let cellModel = NumberRecommendationCollectionViewCellModel(
    roundText: "1181회",
    title: "콩떡님을 위한 로또 번호 추천",
    numbers: [9, 11, 18, 24, 33, 42],
    expectedPrize: "402,396,191원",
    timeUntilDraw: "6일 2시간 59분 32초"
  )
  let cell = NumberRecommendationCollectionViewCell()
  cell.update(with: cellModel)
  cell.snp.makeConstraints { make in
    make.height.equalTo(251)
  }
  return cell
}
