//
//  MyPageSectionBackgroundView.swift
//  Setting
//
//  Created by ttozzi on 7/28/25.
//

import UIKit
import DesignSystem

final class MyPageSectionBackgroundView: UICollectionReusableView {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI() {
    backgroundColor = STColors.white.color
    layer.cornerRadius = 10
    layer.masksToBounds = true
  }
}
