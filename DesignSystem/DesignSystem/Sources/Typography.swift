//
//  Typography.swift
//  DesignSystem
//
//  Created by ttozzi on 7/19/25.
//

import Foundation
import SwiftRichString

public struct Typography {
  
  // MARK: - Display
  public static let Display_28_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 28)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.42)
  }
  public static let Display_26_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 26)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.39)
  }
  
  // MARK: - Heading
  public static let Heading_24_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 24)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.36)
  }
  public static let Heading_24_SB = Style {
    $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 24)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.36)
  }
  public static let Heading_22_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 22)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.33)
  }
  public static let Heading_22_SB = Style {
    $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 22)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.33)
  }
  public static let Heading_20_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 20)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.3)
  }
  public static let Heading_20_SB = Style {
    $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 20)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.3)
  }
  public static let Heading_20_M = Style {
    $0.font = DesignSystemFontFamily.Suit.medium.font(size: 20)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.3)
  }
  public static let Heading_20_R = Style {
    $0.font = DesignSystemFontFamily.Suit.regular.font(size: 20)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.3)
  }
  
  // MARK: - Body
  public static let Body_18_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 18)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.27)
  }
  public static let Body_18_SB = Style {
    $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 18)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.27)
  }
  public static let Body_18_M = Style {
    $0.font = DesignSystemFontFamily.Suit.medium.font(size: 18)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.27)
  }
  public static let Body_18_R = Style {
    $0.font = DesignSystemFontFamily.Suit.regular.font(size: 18)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.27)
  }
  public static let Body_16_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 16)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.24)
  }
  public static let Body_16_SB = Style {
    $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 16)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.24)
  }
  public static let Body_16_M = Style {
    $0.font = DesignSystemFontFamily.Suit.medium.font(size: 16)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.24)
  }
  public static let Body_16_R = Style {
    $0.font = DesignSystemFontFamily.Suit.regular.font(size: 16)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.24)
  }
  public static let Body_14_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 14)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.21)
  }
  public static let Body_14_SB = Style {
    $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 14)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.21)
  }
  public static let Body_14_M = Style {
    $0.font = DesignSystemFontFamily.Suit.medium.font(size: 14)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.21)
  }
  public static let Body_14_R = Style {
    $0.font = DesignSystemFontFamily.Suit.regular.font(size: 14)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.21)
  }
  
  // MARK: - Caption
  public static let Caption_12_B = Style {
    $0.font = DesignSystemFontFamily.Suit.bold.font(size: 12)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.18)
  }
  public static let Caption_12_SB = Style {
    $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 12)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.18)
  }
  public static let Caption_12_M = Style {
    $0.font = DesignSystemFontFamily.Suit.medium.font(size: 12)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.18)
  }
  public static let Caption_12_R = Style {
    $0.font = DesignSystemFontFamily.Suit.regular.font(size: 12)
    $0.lineHeightMultiple = 1.2
    $0.kerning = .point(0.18)
  }
}
