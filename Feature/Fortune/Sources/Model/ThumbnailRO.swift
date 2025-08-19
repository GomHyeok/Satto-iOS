//
//  ThumbnailRO.swift
//  CoreLayer
//
//  Created by 최재혁 on 8/13/25.
//

public struct ThumbnailRO {
  public let sajuMyeongSik: SajuMyeongSik
  public let overallFortuneText: String

  public init(sajuMyeongSik: SajuMyeongSik, overallFortuneText: String) {
    self.sajuMyeongSik = sajuMyeongSik
    self.overallFortuneText = overallFortuneText
  }
}

public struct SajuMyeongSik {
  public let siJu: SajuPair?
  public let ilJu: SajuPair
  public let wolJu: SajuPair
  public let nyeongJu: SajuPair
}

public struct SajuPair {
  public let stem: String
  public let branch: String
  public let stemTenGod : String
  public let branchTenGod : String
}
