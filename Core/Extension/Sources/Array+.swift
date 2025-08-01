//
//  Array+.swift
//  Extension
//
//  Created by ttozzi on 8/1/25.
//

import Foundation

extension Array {
  public subscript(safe index: Int) -> Element? {
    return (index >= .zero && index < count) ? self[index] : nil
  }
}
