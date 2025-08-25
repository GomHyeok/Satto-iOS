//
//  MyPageViewModel.swift
//  Setting
//
//  Created by ttozzi on 7/29/25.
//

import Auth
import Base
import Combine
import DIInjector
import Foundation
import Lib
import UIKit

enum PopUpType {
  case deleteUser
}

public final class MyPageViewModel {

  enum Input {
    case viewDidLoad
    case editButtonTapped
    case feedBackButtonTapped
    case menuTapped(item: MyPageMenu)
    case deleteUser
  }

  struct Output {
    let sections = CurrentValueSubject<[MyPageSection], Never>([])
    let showToast = PassthroughSubject<Void, Never>()
    let showWebView = PassthroughSubject<URL, Never>()
    let isLoading = PassthroughSubject<Bool, Never>()
    let updatePopupHidden = PassthroughSubject<PopUpType, Never>()
    let showError = PassthroughSubject<() -> Void, Never>()
  }

  @Injected private var myPageService: MyPageService
  @Injected private var router: SettingRouter
  @Injected private var userDataManager: UserDataManager
  @Injected private var dependencyHandler: DependencyHandler

  let output: Output = Output()
  private var cancellables = Set<AnyCancellable>()

  public init() {
    userDataManager.getPublisher()
      .sink { [weak self] _ in
        guard let self else { return }
        self.fetchUser()
        self.output.showToast.send()
      }
      .store(in: &cancellables)
  }

  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      fetchUser()

    case .editButtonTapped:
      Task { @MainActor [weak self] in
        guard let self else { return }
        self.router.navigate(
          to: SettingRoute.editProfile, how: .push(hidesBottomBarWhenPushed: true),
          with: [:])
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

      case .deleteUserInfo:
        output.updatePopupHidden.send(.deleteUser)

      case .appVersion:
        break
      }

    case .deleteUser:
      Task { [weak self] in
        guard let self else { return }
        async let minDelay: Void = Task.sleep(for: .seconds(2))
        output.isLoading.send(true)
        do {
          try await userDataManager.delete()
          let _ = try? await minDelay
          output.isLoading.send(false)
          self.dependencyHandler.handle(key: DependencyKey.App.moveToSplashViewController)
        } catch {
          output.isLoading.send(false)
          output.showError.send { [weak self] in
            guard let self else { return }
            self.send(input: .deleteUser)
          }
        }
      }
      break
    }
  }
}

extension MyPageViewModel {
  public func fetchUser() {
    output.isLoading.send(true)
    Task { [weak self] in
      guard let self else { return }
      do {
        // TODO: 로딩 인디케이터
        let sections = try await self.myPageService.fetch()
        self.output.sections.send(sections)
        self.output.isLoading.send(false)
      } catch {
        // TODO: 에러 처리
        output.isLoading.send(false)
        output.showError.send { [weak self] in
          guard let self else { return }
          self.fetchUser()
        }
      }
    }
  }
}
