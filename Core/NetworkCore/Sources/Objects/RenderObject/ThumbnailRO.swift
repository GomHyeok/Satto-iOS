//
//  ThumbnailRO.swift
//  CoreLayer
//
//  Created by 최재혁 on 8/13/25.
//

public struct ThumbnailRO {
    public let sajuMyeongSik: SajuMyeongSik
    public let overallFortuneText : String
    
    public init(sajuMyeongSik: SajuMyeongSik, overallFortuneText: String) {
        self.sajuMyeongSik = sajuMyeongSik
        self.overallFortuneText = overallFortuneText
    }
}

public struct SajuMyeongSik {
    public let siJu : SajuPair?
    public let ilJu : SajuPair
    public let wolJu : SajuPair
    public let nyeongJu : SajuPair
    
    public init(siJu: SajuPair?, ilJu: SajuPair, wolJu: SajuPair, nyeongJu: SajuPair) {
        self.siJu = siJu
        self.ilJu = ilJu
        self.wolJu = wolJu
        self.nyeongJu = nyeongJu
    }
}

public struct SajuPair {
    public let cheonGan : String
    public let jiji : String
    
    public init(cheonGan: String, jiji: String) {
        self.cheonGan = cheonGan
        self.jiji = jiji
    }
}


