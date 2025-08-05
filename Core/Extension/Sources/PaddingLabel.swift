//
//  PaddingLabel.swift
//  Extension
//
//  Created by ttozzi on 8/3/25.
//

import UIKit

public final class PaddingLabel: UILabel {
  
  public var contentInsets: UIEdgeInsets = .zero {
    didSet {
      invalidateIntrinsicContentSize()
    }
  }
  
  public override func drawText(in rect: CGRect) {
    let insetRect = rect.inset(by: contentInsets)
    super.drawText(in: insetRect)
  }
  
  public override var intrinsicContentSize: CGSize {
    let size = super.intrinsicContentSize
    return CGSize(
      width: size.width + contentInsets.left + contentInsets.right,
      height: size.height + contentInsets.top + contentInsets.bottom
    )
  }
}
