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
  private lazy var backgroundImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.backgroundColor = STColors.gray8.color
    $0.clipsToBounds = true
  }
  public var number: String? {
    get { numberLabel.text }
    set {
      let backgroundImage = BallBackgroundImageFactory.makeImage(of: newValue)
      backgroundImageView.image = backgroundImage
      numberLabel.styledText = newValue
    }
  }
  public var isColored: Bool = true {
    didSet {
      update(isColored: isColored)
    }
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    backgroundImageView.layer.cornerRadius =
      min(backgroundImageView.bounds.width, backgroundImageView.bounds.height) / 2
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

  private func update(isColored: Bool) {
    if isColored {
      let backgroundImage = BallBackgroundImageFactory.makeImage(of: number)
      backgroundImageView.image = backgroundImage
    } else {
      backgroundImageView.image = nil
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
    case 1...10:
      return STImages.ballYellow.image
    case 11...20:
      return STImages.ballBlue.image
    case 21...30:
      return STImages.ballRed.image
    case 31...40:
      return STImages.ballGray.image
    case 41...45:
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
  let uncoloredBall = Ball()
  uncoloredBall.number = "1"
  uncoloredBall.isColored = false
  stackView.addArrangedSubview(uncoloredBall)
  stackView.arrangedSubviews.forEach {
    $0.snp.makeConstraints { make in
      make.size.equalTo(32)
    }
  }
  return stackView
}
