//
//  NumberCardItemView.swift
//  Home
//
//  Created by ttozzi on 8/9/25.
//

import UIKit
import DesignSystem

struct NumberCardItem {
  let title: String
  let numbers: [Int]
}

final class NumberCardItemView: UIView {
  
  private lazy var contentStackView = UIStackView().then {
    $0.spacing = 20
    $0.axis = .vertical
    $0.alignment = .leading
  }
  private lazy var titleLabel = UILabel().then {
    $0.style = Typography.Body_14_SB.lineHeightMultiple(1.2)
    $0.textColor = STColors.gray1.color
    $0.numberOfLines = 2
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
    backgroundColor = STColors.gray9.color
    clipsToBounds = true
    layer.cornerRadius = 10
    
    addSubview(contentStackView)
    contentStackView.snp.makeConstraints { make in
      make.edges.equalToSuperview().inset(16)
    }
    
    contentStackView.addArrangedSubview(titleLabel)
    
    contentStackView.addArrangedSubview(numberBallStackView)
  }
  
  func update(with item: NumberCardItem) {
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
  let item = NumberCardItem(
    title: "수(水) 기운과\n상충하는 숫자",
    numbers: [9, 11, 18]
  )
  let view = NumberCardItemView()
  view.update(with: item)
  return view
}
