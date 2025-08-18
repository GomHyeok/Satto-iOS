//
//  MyPageViewModel.swift
//  Setting
//
//  Created by ttozzi on 7/29/25.
//

import Combine
import DIInjector
import Foundation
import Lib

public final class MyPageViewModel {

  enum Input {
    case viewDidLoad
    case editButtonTapped
    case feedBackButtonTapped
    case menuTapped(item: MyPageMenuCollectionViewCellModel)
  }

  struct Output {
    let sections = CurrentValueSubject<[MyPageSection], Never>([])
    let showToadt: PassthroughSubject<Void, Never> = .init()
  }

  @Injected private var myPageService: MyPageService
  @Injected private var router : SettingRouter
  
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
      // TODO: 피드백 전송 링크
      break
      
    case .menuTapped(let item):
      // TODO: menu 핸들링
      break
    }
  }
}

extension MyPageViewModel: EditProfileViewControllerProtocol {
  public func showToast() {
    self.send(input: .viewDidLoad)
    self.output.showToadt.send(())
  }
}
