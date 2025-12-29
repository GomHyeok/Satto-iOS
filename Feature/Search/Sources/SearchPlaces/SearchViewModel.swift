//
//  SearchViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 12/28/25.
//

import Foundation
import Combine

import DIInjector

public final class SearchViewModel {
  
  enum Input {
    case viewDidLoad
    case searchPlace(query: String)
  }
  
  enum EmptyCase {
    case none
    case offline
    case before
  }
  
  struct Output {
    let _isLoading = PassthroughSubject<Bool, Never>()
    let _showError = PassthroughSubject<() -> Void, Never>()
    let _changeEmptyView = PassthroughSubject<EmptyCase, Never>()
    
    var isLoading : AnyPublisher<Bool, Never> {
      _isLoading.eraseToAnyPublisher()
    }
    var showError : AnyPublisher<() -> Void, Never> {
      _showError.eraseToAnyPublisher()
    }
    var changeEmptyView : AnyPublisher<EmptyCase, Never> {
      _changeEmptyView.eraseToAnyPublisher()
    }
  }
  
  let output: Output = Output()
  private var cancellables = Set<AnyCancellable>()
  
  func send(input : Input) {
    
  }
}

extension SearchViewModel {
  
}
