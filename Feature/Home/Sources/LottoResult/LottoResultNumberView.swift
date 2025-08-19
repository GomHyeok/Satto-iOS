//
//  LottoResultNumberView.swift
//  Home
//
//  Created by ttozzi on 8/20/25.
//

import Base
import DesignSystem
import UIKit
import SwiftRichString

struct LottoResultNumberModel {
  let rankText: String?
  let winningNumbers: [Int]
  let bonusNumber: Int
  let recommendedNumbers: [Int]
}

final class LottoResultNumberView: UIView {
  
  private lazy var resultStackView = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 20
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func update(with model: LottoResultNumberModel) {
    resultStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    let winningNumbersView = makeWinningNumbersView(
      numbers: model.winningNumbers,
      bonusNumber: model.bonusNumber
    )
    resultStackView.addArrangedSubview(winningNumbersView)
    
    let resultView = makeResultView(
      rankText: model.rankText,
      recommendedNumbers: model.recommendedNumbers,
      winningNumbers: model.winningNumbers
    )
    resultStackView.addArrangedSubview(resultView)
  }

  private func setupUI() {
    addSubview(resultStackView)
    resultStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
  }
  
  private func makeContainerStackView() -> UIStackView {
    return UIStackView().then {
      $0.axis = .horizontal
      $0.distribution = .equalSpacing
      $0.alignment = .center
      $0.isLayoutMarginsRelativeArrangement = true
      $0.layoutMargins = UIEdgeInsets(top: 16, left: 20, bottom: 16, right: 20)
      $0.backgroundColor = STColors.white.color
      $0.layer.cornerRadius = 30
      $0.clipsToBounds = true
    }
  }
  
  private func makeWinningNumbersView(numbers: [Int], bonusNumber: Int) -> UIView {
    let stackView = makeContainerStackView()
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

  private func makeResultView(
    rankText: String?,
    recommendedNumbers: [Int],
    winningNumbers: [Int]
  ) -> UIView {
    let stackView = makeContainerStackView()
    
    let rankView = UIView().then {
      $0.backgroundColor = STColors.primary2.color
      $0.layer.cornerRadius = 16
      $0.clipsToBounds = true
    }
    let rankLabel = UILabel().then {
      $0.style = Style {
        $0.font = DesignSystemFontFamily.Suit.extraBold.font(size: 12)
        $0.kerning = .point(-0.18)
        $0.color = STColors.white.color
      }
      $0.styledText = rankText
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

    recommendedNumbers.forEach { number in
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
