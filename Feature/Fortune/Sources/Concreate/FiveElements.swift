//
//  FiveElements.swift
//  FeatureLayer
//
//  Created by 최재혁 on 8/14/25.
//

import DesignSystem
import UIKit

enum FiveElements {
  case wood, fire, earth, metal, water, null

  var color: UIColor {
    switch self {
    case .wood:
      return STColors.green4.color
    case .fire:
      return STColors.red4.color
    case .earth:
      return STColors.yellow4.color
    case .metal:
      return STColors.gray4.color
    case .water:
      return STColors.blue4.color
    case .null:
      return STColors.gray6.color
    }
  }

  var kor: String {
    switch self {
    case .wood:
      return "목"
    case .fire:
      return "화"
    case .earth:
      return "토"
    case .metal:
      return "금"
    case .water:
      return "수"
    case .null:
      return "-"
    }
  }
}
