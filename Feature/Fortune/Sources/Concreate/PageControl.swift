//
//  PageControl.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/12/25.
//

import UIKit

class CustomPageControl: UIView {
  var numberOfPages: Int = 0 {
    didSet {
      setupDots()
    }
  }
  var currentPage: Int = 0 {
    didSet {
      updateDots()
    }
  }

  private var dots: [UIView] = []

  private let selectedDotWidth: CGFloat = 20
  private let normalDotWidth: CGFloat = 10
  private let dotHeight: CGFloat = 6
  private let dotSpacing: CGFloat = 8

  private func setupDots() {
    dots.forEach { $0.removeFromSuperview() }
    dots.removeAll()

    guard numberOfPages > 0 else { return }

    for _ in 0..<numberOfPages {
      let dot = UIView()
      dot.layer.cornerRadius = dotHeight / 2
      dot.backgroundColor = .lightGray
      addSubview(dot)
      dots.append(dot)
    }
    updateDots()
    setNeedsLayout()
  }

  private func updateDots() {
    for (index, dot) in dots.enumerated() {
      if index == currentPage {
        dot.backgroundColor = UIColor.purple
        dot.frame.size.width = selectedDotWidth
      } else {
        dot.backgroundColor = UIColor.systemPurple.withAlphaComponent(0.3)
        dot.frame.size.width = normalDotWidth
      }
      dot.layer.cornerRadius = dotHeight / 2
    }
    setNeedsLayout()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    var x: CGFloat = 0
    for dot in dots {
      let width = dot.frame.size.width
      dot.frame = CGRect(x: x, y: (bounds.height - dotHeight) / 2, width: width, height: dotHeight)
      x += width + dotSpacing
    }
  }
}
