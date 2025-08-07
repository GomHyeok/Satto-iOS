//
//  Ball.swift
//  DesignSystem
//
//  Created by ttozzi on 8/6/25.
//

import SwiftRichString
import Then
import UIKit

public final class Ball: UIView {

  private lazy var numberLabel = UILabel().then {
    $0.style = Style {
      $0.font = DesignSystemFontFamily.Suit.extraBold.font(size: 14)
      $0.kerning = .point(0.21)
      $0.color = STColors.white.color
    }
  }
  private lazy var backgroundImageView = UIImageView()
  public var number: String? {  // TODO: 타입 확인
    get { numberLabel.text }
    set {
      let backgroundImage = BallBackgroundImageFactory.makeImage(of: newValue)
      backgroundImageView.image = backgroundImage
      numberLabel.styledText = newValue
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    addSubview(backgroundImageView)
    backgroundImageView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    backgroundImageView.addSubview(numberLabel)
    numberLabel.snp.makeConstraints { make in
      make.center.equalToSuperview()
    }
  }
}

private enum BallBackgroundImageFactory {

  static func makeImage(of number: String?) -> UIImage? {
    guard let number, let n = Int(number) else {
      // TODO: ?
      return nil
    }
    switch n {
    case 1...9:
      return STImages.ballYellow.image
    case 10...19:
      return STImages.ballBlue.image
    case 20...29:
      return STImages.ballRed.image
    case 30...39:
      return STImages.ballGray.image
    case 40...45:
      return STImages.ballGreen.image
    default:
      return nil
    }
  }
}

@available(iOS 17.0, *)
#Preview {
  let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8
  }
  let numbers = ["9", "18", "23", "34", "42"]
  numbers.forEach { number in
    let ball = Ball()
    ball.number = number
    stackView.addArrangedSubview(ball)
  }
  return stackView
}
