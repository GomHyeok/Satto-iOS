//
//  LottieAnimations.swift
//  DesignSystem
//
//  Created by ttozzi on 8/17/25.
//

import Foundation
import Lottie

public enum LottieFiles: CaseIterable {

  enum Format {
    case json
    case lottie

    var ext: String {
      switch self {
      case .json:
        return "json"
      case .lottie:
        return "lottie"
      }
    }
  }

  case lottoResultText
  case lottoResultPig
  case confettiiii

  var name: String {
    switch self {
    case .lottoResultText:
      return "lotto_result_text"
    case .lottoResultPig:
      return "lotto_result_pig"
    case .confettiiii:
      return "Confettiiii"
    }
  }
  var format: Format {
    switch self {
    case .lottoResultText,
      .lottoResultPig:
      return .json
    case .confettiiii:
      return .lottie
    }
  }
  var url: URL? {
    Bundle.module.url(forResource: name, withExtension: format.ext)
  }
}

public enum LottieAnimations {

  public static func loadAnimation(_ file: LottieFiles) async -> LottieAnimationView? {
    guard let url = file.url else {
      return nil
    }
    switch file.format {
    case .json:
      let animation = await LottieAnimation.loadedFrom(url: url)
      return await LottieAnimationView(animation: animation)
    case .lottie:
      guard let animation = try? await DotLottieFile.loadedFrom(url: url) else {
        return nil
      }
      return await LottieAnimationView(dotLottie: animation)
    }
  }
}
