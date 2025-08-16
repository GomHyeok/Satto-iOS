//
//  MyPageService.swift
//  Setting
//
//  Created by ttozzi on 7/29/25.
//

import Auth
import DIInjector
import DesignSystem
import Foundation
import NetworkCore

struct MyPageService {

  @Injected private var userDataManager: UserDataManager

  func fetch() async throws -> [MyPageSection] {
    let userData = try await userDataManager.fetch()
    let gender = switch userData.gender {
    case .male:
      "남"
    case .female:
      "여"
    }
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    return [
      .profile(
        MyProfileInfoCollectionViewCellModel(
          nickname: userData.name,
          gender: gender,
          birthDate: "1999-12-25", // TODO: 서버 데이터 양식 확인 필요
          birthTime: "01:00 ~ 02:59" // TODO: 서버 데이터 양식 확인 필요
        )
      ),
      .feedback(
        SendFeedbackCollectionViewCellModel(
          description: "더 나은 서비스를 위해,\n여러분의 목소리를 들려주세요",
          feedbackButtonTitle: "의견 보내기"
        )
      ),
      .menu([
        MyPageMenuCollectionViewCellModel(
          style: .icon(STImages.chevronRightS.image), title: "푸시알림"),
        MyPageMenuCollectionViewCellModel(
          style: .icon(STImages.chevronRightS.image), title: "이용약관"),
        MyPageMenuCollectionViewCellModel(
          style: .icon(STImages.chevronRightS.image), title: "개인정보 처리방침"),
        MyPageMenuCollectionViewCellModel(style: .text(appVersion ?? "1.0.0"), title: "앱 버전"),
      ]),
    ]
  }
}
