//
//  RankViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/12/26.
//

import Foundation
import Combine
import DIInjector

public final class RankViewModel {
  public init() {}
  
  enum Input {
    case viewDidLoad
    case selectRegion(String)
  }
  
  struct Output {
    fileprivate let _showPlaces = CurrentValueSubject<[RankPlaceCellModel], Never>([])
    fileprivate let _setDate = PassthroughSubject<String, Never>()
    fileprivate let _showLoading = PassthroughSubject<Bool, Never>()
    fileprivate let _showError = PassthroughSubject<() -> Void, Never>()
    
    var showPlaces : AnyPublisher<[RankPlaceCellModel], Never> {
      _showPlaces.eraseToAnyPublisher()
    }
    
    var setDate: AnyPublisher<String, Never> {
      _setDate.eraseToAnyPublisher()
    }
    
    var showLoading: AnyPublisher<Bool, Never> {
      _showLoading.eraseToAnyPublisher()
    }
    
    var showError: AnyPublisher<() -> Void, Never> {
      _showError.eraseToAnyPublisher()
    }
  }
  
  let output: Output = Output()
  
  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      let dateString : String = getDateString(from: Date())
      output._showPlaces.send(dummyData)
      output._setDate.send(dateString + " 기준")
    case .selectRegion(let region):
      output._showPlaces.send(dummyData)
    }
  }
  
  func getPlacesCount() -> Int {
    return output._showPlaces.value.count
  }
  
  func getSection(at index: Int) -> RankPlaceCellModel? {
    let sections = output._showPlaces.value
    return sections[safe: index]
  }
  
  let dummyData: [ RankPlaceCellModel] = [
    RankPlaceCellModel(id: "123", index: 0, title: "서울특별시 종로구 종로 1", address: "서울특별시 종로구 종로 1", count: 100, auto: 50, manual: 30, semi: 20),
    RankPlaceCellModel(id: "123", index: 1, title: "서울특별시 종로구 종로 2", address: "서울특별시 종로구 종로 2", count: 90, auto: 40, manual: 30, semi: 20),
    RankPlaceCellModel(id: "123", index: 2, title: "서울특별시 종로구 종로 3", address: "서울특별시 종로구 종로 3", count: 80, auto: 30, manual: 30, semi: 20),
  ]
}

extension RankViewModel {
  private func getDateString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }
}

