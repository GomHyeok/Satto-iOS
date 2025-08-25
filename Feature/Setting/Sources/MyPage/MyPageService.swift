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
    let gender =
      switch userData.gender {
      case .male:
        "남"
      case .female:
        "여"
      }
    let birthTime = {
      if let time = userData.birthTime {
        return "\(time[0]) ~ \(time[1])"
      }

      return "알수 없소"
    }()
    let birthDate = userData.birthDate ?? "알수 없소"
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    return [
      .profile(
        MyProfileInfoCollectionViewCellModel(
          nickname: userData.name,
          gender: gender,
          birthDate: birthDate,
          birthTime: birthTime
        )
      ),
      .feedback(
        SendFeedbackCollectionViewCellModel(
          description: "더 나은 서비스를 위하여,\n그대의 목소리를 들려주시게",
          feedbackButtonTitle: "의견 보내기"
        )
      ),
      .menu([
        .termsOfService(
          MyPageMenuCollectionViewCellModel(
            style: .icon(STImages.chevronRightS.image), title: "이용약관")),
        .privacyPolicy(
          MyPageMenuCollectionViewCellModel(
            style: .icon(STImages.chevronRightS.image), title: "개인정보 처리방침")),
        .deleteUserInfo(MyPageMenuCollectionViewCellModel(style: .icon(STImages.chevronRightS.image), title: "정보 삭제")),
        .appVersion(
          MyPageMenuCollectionViewCellModel(style: .text(appVersion ?? "1.0.0"), title: "앱 버전"))
      ]),
    ]
  }
}

enum MyPageMenu {

  case termsOfService(MyPageMenuCollectionViewCellModel)
  case privacyPolicy(MyPageMenuCollectionViewCellModel)
  case appVersion(MyPageMenuCollectionViewCellModel)
  case deleteUserInfo(MyPageMenuCollectionViewCellModel)

  var item: MyPageMenuCollectionViewCellModel {
    switch self {
    case .termsOfService(let myPageMenuCollectionViewCellModel),
      .privacyPolicy(let myPageMenuCollectionViewCellModel),
      .appVersion(let myPageMenuCollectionViewCellModel),
      .deleteUserInfo(let myPageMenuCollectionViewCellModel):
      return myPageMenuCollectionViewCellModel
    }
  }
}
