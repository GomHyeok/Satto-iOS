//
//  BaseCollectionViewCell.swift
//  Base
//
//  Created by ttozzi on 8/10/25.
//

import Combine
import UIKit

open class BaseCollectionViewCell: UICollectionViewCell {
  
  public var cancellables = Set<AnyCancellable>()
  
  open override func prepareForReuse() {
    super.prepareForReuse()
    cancellables.removeAll()
  }
}
