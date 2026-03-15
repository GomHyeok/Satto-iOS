//
//  WeeklyPlaceViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 3/10/26.
//

import Combine
import DIInjector
import Foundation

public final class WeeklyPlaceViewModel {
  public init(){}
  
  enum Input {
    case viewDidLoad
    case selectPlaceRank(Int)
  }
  
  struct Output {
    fileprivate let _showPlaces = CurrentValueSubject<[WeeklyPlaceCellModel], Never>([])
    fileprivate let _setRoundAndDate = PassthroughSubject<(round: String, date: String), Never>()
    fileprivate let _showLoading = PassthroughSubject<Bool, Never>()
    fileprivate let _showError = PassthroughSubject<() -> Void, Never>()
    
    var showPlaces : AnyPublisher<[WeeklyPlaceCellModel], Never> {
      _showPlaces.eraseToAnyPublisher()
    }
    
    var setRoundAndDate : AnyPublisher<(round: String, date: String), Never> {
      _setRoundAndDate.eraseToAnyPublisher()
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
      output._showPlaces.send(dummyData)
      output._setRoundAndDate.send((round: "1234회", date: getDateString(from: Date())))
    case .selectPlaceRank(let rank):
      output._showPlaces.send(dummyData)
    }
  }
  
  func getPlacesCount() -> Int {
    return output._showPlaces.value.count
  }
  
  func getSection(at index: Int) -> WeeklyPlaceCellModel? {
    let sections = output._showPlaces.value
    return sections[safe: index]
  }
  
  let dummyData: [WeeklyPlaceCellModel] = [
    WeeklyPlaceCellModel(id: "123", index: 0, title: "서울특별시 종로구 종로 1", address: "서울특별시 종로구 종로 1"),
    WeeklyPlaceCellModel(id: "123", index: 1, title: "서울특별시 종로구 종로 2", address: "서울특별시 종로구 종로 2"),
    WeeklyPlaceCellModel(id: "123", index: 2, title: "서울특별시 종로구 종로 3", address: "서울특별시 종로구 종로 3"),
  ]
}

extension WeeklyPlaceViewModel {
  private func getDateString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
  }
}
