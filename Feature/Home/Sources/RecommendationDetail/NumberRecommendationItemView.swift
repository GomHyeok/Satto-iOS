//
//  NumberRecommendationItemView.swift
//  Home
//
//  Created by ttozzi on 8/9/25.
//

import UIKit
import DesignSystem

struct NumberRecommendationItem {
  let title: String
  let numbers: [Int]
}

final class NumberRecommendationItemView: UIView {
  
  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 20
    $0.axis = .horizontal
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_14_SB
    $0.textColor = STColors.gray1.color
    $0.setContentHuggingPriority(UILayoutPriority(.zero), for: .horizontal)
  }
  private lazy var numberBallStackView = UIStackView().then {
    $0.spacing = 8
    $0.axis = .horizontal
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    clipsToBounds = true
    layer.borderColor = STColors.gray7.color.cgColor
    layer.borderWidth = 1
    layer.cornerRadius = 8
    
    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(16)
    }
    
    contentStackView.addArrangedSubview(titleLabel)
    
    contentStackView.addArrangedSubview(numberBallStackView)
  }
  
  func update(with item: NumberRecommendationItem) {
    titleLabel.styledText = item.title
    numberBallStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    item.numbers.forEach { number in
      let ball = Ball()
      ball.number = String(number)
      numberBallStackView.addArrangedSubview(ball)
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let item = NumberRecommendationItem(
    title: "화(火) 기운과 잘 맞는 숫자",
    numbers: [9, 11]
  )
  let view = NumberRecommendationItemView()
  view.update(with: item)
  return view
}
