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
  public init() {}
  enum Input {
    case viewDidLoad
    case searchPlace(query: String)
  }
  
  enum EmptyCase {
    case none
    case offline
    case before
    case filled
    
    var title : String {
      switch self {
      case .none :
        return "천하에 검색 결과가 없소"
      case .offline :
        return "오프라인 상태라네"
      case .before :
        return "어느 장소를 찾으시오?"
      case .filled :
        return ""
      }
    }
    
    var subTitle : String {
      switch self {
      case .none :
        return "정확한 지명(구/동) 혹은\n상호명을 입력해 보시게"
      case .offline :
        return "인터넷 연결을 확인해 주시게"
      case .before :
        return "정확한 지명(구/동) 혹은\n상호명을 입력해 보시게"
      case .filled :
        return ""
      }
    }
  }
  
  struct Output {
    fileprivate let _changeBasicView = PassthroughSubject<EmptyCase, Never>()
    fileprivate let _isLoading = PassthroughSubject<Bool, Never>()
    fileprivate let _showError = PassthroughSubject<() -> Void, Never>()
    
    var isLoading : AnyPublisher<Bool, Never> {
      _isLoading.eraseToAnyPublisher()
    }
    var showError : AnyPublisher<() -> Void, Never> {
      _showError.eraseToAnyPublisher()
    }
    var changeBasicView : AnyPublisher<EmptyCase, Never> {
      _changeBasicView.eraseToAnyPublisher()
    }
  }
  
  let output: Output = Output()
  private var cancellables = Set<AnyCancellable>()
  
  func send(input : Input) {
    switch input {
    case .viewDidLoad :
      self.output._changeBasicView.send(.before)
    case .searchPlace(let query) :
      if query.isEmpty {
        self.output._changeBasicView.send(.before)
        return
      }
      
      self.output._changeBasicView.send(.filled)
      searchPlace(query: query)
    }
  }
}

extension SearchViewModel {
    func searchPlace(query: String) {
      
    }
}



