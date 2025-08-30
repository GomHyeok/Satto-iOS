//
//  UIResponder.swift
//  CoreLayer
//
//  Created by 최재혁 on 8/16/25.
//

import UIKit

extension UIResponder {
  private static weak var _currentFirstResponder: UIResponder? = nil

  public static var currentFirstResponder: UIResponder? {
    _currentFirstResponder = nil
    UIApplication.shared.sendAction(
      #selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
    return _currentFirstResponder
  }

  @objc private func findFirstResponder(sender: Any) {
    UIResponder._currentFirstResponder = self
  }
}
