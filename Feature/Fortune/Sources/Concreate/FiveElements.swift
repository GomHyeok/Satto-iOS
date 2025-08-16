//
//  FiveElements.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/14/25.
//

import DesignSystem
import UIKit

enum FiveElements {
  case wood, fire, earth, metal, water

  var color: UIColor {
    switch self {
    case .wood:
      return STColors.green4.color
    case .fire:
      return STColors.red4.color
    case .earth:
      return STColors.yellow4.color
    case .metal:
      return STColors.gray6.color
    case .water:
      return STColors.blue4.color
    }
  }

  var kor: String {
    switch self {
    case .wood:
      return "목(木)"
    case .fire:
      return "화(火)"
    case .earth:
      return "토(土)"
    case .metal:
      return "금(金)"
    case .water:
      return "수(水)"
    }
  }
}
