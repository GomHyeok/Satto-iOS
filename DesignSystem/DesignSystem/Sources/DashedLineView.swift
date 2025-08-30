//
//  DashedLineView.swift
//  DesignSystem
//
//  Created by ttozzi on 8/7/25.
//

import UIKit

public final class DashedLineView: UIView {

  private let color: UIColor

  public init(color: UIColor) {
    self.color = color
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }

    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = color.cgColor
    shapeLayer.lineWidth = 1
    shapeLayer.lineDashPattern = [4, 4]

    let path = CGMutablePath()
    path.addLines(between: [
      CGPoint(x: 0, y: bounds.midY),
      CGPoint(x: bounds.width, y: bounds.midY),
    ])
    shapeLayer.path = path
    layer.addSublayer(shapeLayer)
  }
}

@available(iOS 17.0, *)
#Preview {
  DashedLineView(color: STColors.gray6.color)
}
