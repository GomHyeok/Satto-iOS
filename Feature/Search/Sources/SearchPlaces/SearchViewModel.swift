//
//  SearchViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 12/28/25.
//

import Combine
import DIInjector
import Foundation

public final class SearchViewModel {
  
  enum Input {
    case viewDidLoad
    case searchPlace(query: String)
    case selectPlace(id: String)
  }

  enum EmptyCase {
    case none
    case offline
    case before
    case filled

    var title: String {
      switch self {
      case .none:
        return "천하에 검색 결과가 없소"
      case .offline:
        return "오프라인 상태라네"
      case .before:
        return "어느 장소를 찾으시오?"
      case .filled:
        return ""
      }
    }

    var subTitle: String {
      switch self {
      case .none:
        return "정확한 지명(구/동) 혹은\n상호명을 입력해 보시게"
      case .offline:
        return "인터넷 연결을 확인해 주시게"
      case .before:
        return "정확한 지명(구/동) 혹은\n상호명을 입력해 보시게"
      case .filled:
        return ""
      }
    }
  }

  struct Output {
    fileprivate let _changeBasicView = PassthroughSubject<EmptyCase, Never>()
    fileprivate let _reloadData = CurrentValueSubject<[SearchResultCellModel], Never>([])
    fileprivate let _isLoading = PassthroughSubject<Bool, Never>()
    fileprivate let _showError = PassthroughSubject<() -> Void, Never>()

    var isLoading: AnyPublisher<Bool, Never> {
      _isLoading.eraseToAnyPublisher()
    }
    var showError: AnyPublisher<() -> Void, Never> {
      _showError.eraseToAnyPublisher()
    }
    var changeBasicView: AnyPublisher<EmptyCase, Never> {
      _changeBasicView.eraseToAnyPublisher()
    }

    var reloadData: AnyPublisher<[SearchResultCellModel], Never> {
      _reloadData.eraseToAnyPublisher()
    }
  }

  // MARK: - Properties
  let output: Output = Output()
  private var cancellables = Set<AnyCancellable>()
  
  // MARK: SearchProperties
  @Injected private var searchService : SearchService
  private let querySubject = PassthroughSubject<String, Never>()
  
  public init() {
    querySubject
      .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
      .removeDuplicates()
      .sink { [weak self] query in
        guard let self else { return }
  
        if query.isEmpty {
          self.output._changeBasicView.send(.before)
          return
        }
        self.searchPlace(query: query)
      }
      .store(in: &cancellables)
  }
  
  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      self.output._changeBasicView.send(.before)
      
    case .searchPlace(let query):
      querySubject.send(query)
      
    case .selectPlace(let id):
      // TODO: 장소 선택 처리(화면 이동)
      mockSelectPlacefunc()
    }
  }
}

extension SearchViewModel {
  private func searchPlace(query: String) {
    
    output._isLoading.send(true)
    Task { [weak self] in
      guard let self else { return }
      do {
        let sections = try await searchService.search(query: query)
        
        self.output._isLoading.send(false)
        
        if sections.count == 0 {
          self.output._changeBasicView.send(.none)
          return
        } else {
          self.output._changeBasicView.send(.filled)
          self.output._reloadData.send(sections)
        }
      } catch {
        self.output._isLoading.send(false)
        // TODO: ErrorHandling
      }
    }
  }

  private func mockSelectPlacefunc() {

  }

  func getSectionCount() -> Int {
    return output._reloadData.value.count
  }

  func getSection(at index: Int) -> SearchResultCellModel? {
    let sections = output._reloadData.value
    return sections[safe: index]
  }
}
