//
//  Numeric+.swift
//  Extension
//
//  Created by ttozzi on 8/20/25.
//

import Foundation

extension Numeric {
  public var formattedWithSeparator: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.groupingSeparator = ","
    formatter.maximumFractionDigits = 0
    return formatter.string(for: self) ?? "\(self)"
  }
}
