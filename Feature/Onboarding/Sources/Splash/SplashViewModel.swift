//
//  SplashViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 7/23/25.
//

import Combine
import DIInjector
import Foundation
import Lib

public enum SplashInputType {
  case navigateToOnboarding
}

public protocol SplashViewModelOutput {

}

public protocol SplashViewModelProtocol: SplashViewModelOutput {
  var inputStream: PassthroughSubject<SplashInputType, Never> { get }
}

public final class SplashViewModel: SplashViewModelProtocol {
  private var store: [AnyCancellable] = []

  public init() {
    inputStream
      .sink { [weak self] type in
        guard let self = self else { return }
        // TODO: router 통해서 view 이동 (lottie를 overlay할지?)
        switch type {
        case .navigateToOnboarding: break

        }
      }
      .store(in: &store)
  }

  public var inputStream: PassthroughSubject<SplashInputType, Never> = .init()
}
