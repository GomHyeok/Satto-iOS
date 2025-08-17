//
//  Typography.swift
//  DesignSystem
//
//  Created by ttozzi on 7/19/25.
//

import SwiftRichString
import UIKit

public struct Typography {

  // MARK: - Display
  public static var Display_28_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 28)
      $0.kerning = .point(0.42)
    }
  }
  public static var Display_26_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 26)
      $0.kerning = .point(0.39)
    }
  }

  // MARK: - Heading
  public static var Heading_24_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 24)
      $0.kerning = .point(0.36)
    }
  }
  public static var Heading_24_SB: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 24)
      $0.kerning = .point(0.36)
    }
  }
  public static var Heading_22_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 22)
      $0.kerning = .point(0.33)
    }
  }
  public static var Heading_22_SB: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 22)
      $0.kerning = .point(0.33)
    }
  }
  public static var Heading_20_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 20)
      $0.kerning = .point(0.3)
    }
  }
  public static var Heading_20_SB: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 20)
      $0.kerning = .point(0.3)
    }
  }
  public static var Heading_20_M: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.medium.font(size: 20)
      $0.kerning = .point(0.3)
    }
  }
  public static var Heading_20_R: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.regular.font(size: 20)
      $0.kerning = .point(0.3)
    }
  }

  // MARK: - Body
  public static var Body_18_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 18)
      $0.kerning = .point(0.27)
    }
  }
  public static var Body_18_SB: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 18)
      $0.kerning = .point(0.27)
    }
  }
  public static var Body_18_M: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.medium.font(size: 18)
      $0.kerning = .point(0.27)
    }
  }
  public static var Body_18_R: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.regular.font(size: 18)
      $0.kerning = .point(0.27)
    }
  }
  public static var Body_16_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 16)
      $0.kerning = .point(0.24)
    }
  }
  public static var Body_16_SB: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 16)
      $0.kerning = .point(0.24)
    }
  }
  public static var Body_16_M: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.medium.font(size: 16)
      $0.kerning = .point(0.24)
    }
  }
  public static var Body_16_R: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.regular.font(size: 16)
      $0.kerning = .point(0.24)
    }
  }
  public static var Body_14_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 14)
      $0.kerning = .point(0.21)
    }
  }
  public static var Body_14_SB: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 14)
      $0.kerning = .point(0.21)
    }
  }
  public static var Body_14_M: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.medium.font(size: 14)
      $0.kerning = .point(0.21)
    }
  }
  public static var Body_14_R: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.regular.font(size: 14)
      $0.kerning = .point(0.21)
    }
  }

  // MARK: - Caption
  public static var Caption_12_B: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.bold.font(size: 12)
      $0.kerning = .point(0.18)
    }
  }
  public static var Caption_12_SB: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.semiBold.font(size: 12)
      $0.kerning = .point(0.18)
    }
  }
  public static var Caption_12_M: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.medium.font(size: 12)
      $0.kerning = .point(0.18)
    }
  }
  public static var Caption_12_R: Style {
    Style {
      $0.font = DesignSystemFontFamily.Suit.regular.font(size: 12)
      $0.kerning = .point(0.18)
    }
  }
}

extension Style {
  public func lineHeightMultiple(_ value: CGFloat) -> Style {
    paragraph.lineHeightMultiple = value
    return self
  }

  public func color(_ value: UIColor) -> Style {
    color = value
    return self
  }

  public func alignment(_ value: NSTextAlignment) -> Style {
    alignment = value
    return self
  }
}
