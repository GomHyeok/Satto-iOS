//
//  MyPageService.swift
//  Setting
//
//  Created by ttozzi on 7/29/25.
//

import Foundation
import NetworkCore
import DesignSystem

struct MyPageService {
  
  private let networkProvider: NetworkProvider
  
  init(networkProvider: NetworkProvider = .shared) {
    self.networkProvider = networkProvider
  }
  
  func fetch() async throws -> [MyPageSection] {
    // TODO: 서버 통신
    try await Task.sleep(for: .seconds(2))
    return [
      .profile(
        MyProfileInfoCollectionViewCellModel(
          nickname: "콩떡",
          gender: "여",
          birthDate: "1999-12-25",
          birthTime: "01:00 ~ 02:59"
        )
      ),
      .feedback(
        SendFeedbackCollectionViewCellModel(
          description: "더 나은 서비스를 위해,\n여러분의 목소리를 들려주세요",
          feedbackButtonTitle: "의견 보내기"
        )
      ),
      .menu([
        MyPageMenuCollectionViewCellModel(style: .icon(STImages.chevronRightS.image), title: "푸시알림"),
        MyPageMenuCollectionViewCellModel(style: .icon(STImages.chevronRightS.image), title: "이용약관"),
        MyPageMenuCollectionViewCellModel(style: .icon(STImages.chevronRightS.image), title: "개인정보 처리방침"),
        MyPageMenuCollectionViewCellModel(style: .text("1.0.0"), title: "앱 버전"),
      ])
    ]
  }
}
