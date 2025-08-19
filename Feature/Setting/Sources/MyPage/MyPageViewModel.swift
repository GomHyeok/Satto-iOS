//
//  MyPageViewModel.swift
//  Setting
//
//  Created by ttozzi on 7/29/25.
//

import Base
import Combine
import DIInjector
import Foundation
import Lib
import UIKit

public final class MyPageViewModel {

  enum Input {
    case viewDidLoad
    case editButtonTapped
    case feedBackButtonTapped
    case menuTapped(item: MyPageMenu)
  }

  struct Output {
    let sections = CurrentValueSubject<[MyPageSection], Never>([])
    let showToast = PassthroughSubject<Void, Never>()
    let showWebView = PassthroughSubject<URL, Never>()
  }

  @Injected private var myPageService: MyPageService
  @Injected private var router: SettingRouter

  let output: Output = Output()

  public init() {}

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      Task { [weak self] in
        guard let self else { return }
        do {
          // TODO: 로딩 인디케이터
          let sections = try await self.myPageService.fetch()
          self.output.sections.send(sections)
        } catch {
          // TODO: 에러 처리
        }
      }

    case .editButtonTapped:
      Task { @MainActor [weak self] in
        guard let self else { return }
        self.router.navigate(
          to: SettingRoute.editProfile, how: .push(hidesBottomBarWhenPushed: true),
          with: ["delegate": self])
      }
    case .feedBackButtonTapped:
      if let url = URL(string: ExternalLinks.feedbackChannel.rawValue) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      }

    case .menuTapped(let menu):
      switch menu {
      case .termsOfService:
        let urlString = ExternalLinks.terms.rawValue
        if let url = URL(string: urlString) {
          output.showWebView.send(url)
        }

      case .privacyPolicy:
        let urlString = ExternalLinks.infoProvision.rawValue
        if let url = URL(string: urlString) {
          output.showWebView.send(url)
        }

      case .appVersion:
        break
      }
    }
  }
}

extension MyPageViewModel: EditProfileViewControllerProtocol {
  public func showToast() {
    self.send(input: .viewDidLoad)
    self.output.showToast.send(())
  }
}
