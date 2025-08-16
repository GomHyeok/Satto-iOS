//
//  NavigationBarItem.swift
//  Base
//
//  Created by ttozzi on 8/10/25.
//

import DesignSystem
import UIKit

public protocol NavigationBarItem: UIView {}

public final class NaivgationBarButtonItem: UIButton, NavigationBarItem {

  public override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    snp.makeConstraints { make in
      make.size.equalTo(24)
    }
  }
}

extension NaivgationBarButtonItem {
  public static var back: NaivgationBarButtonItem {
    let item = NaivgationBarButtonItem()
    item.setImage(STImages.chevronLeftM.image, for: .normal)
    return item
  }
}

public final class NavigationImageItem: UIImageView, NavigationBarItem {

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupUI() {
    contentMode = .scaleAspectFit
    snp.makeConstraints { make in
      make.width.equalTo(74)
      make.height.equalTo(20)
    }
  }
}

extension NavigationImageItem {
  public static var logo: NavigationImageItem {
    let item = NavigationImageItem(frame: .zero)
    item.image = STImages.navigationLogo.image
    return item
  }

}
