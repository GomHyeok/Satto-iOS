//
//  PlaceViewModel.swift
//  FeatureLayer
//
//  Created by 최재혁 on 2/18/26.
//

import Foundation
import DIInjector
import Combine

public final class PlaceViewModel {
  public init() {}
  
  enum Input {
    case viewDidLoad
    case selectSegment(index: Int)
  }
  
  struct Output {
    fileprivate let _showWeeklyPlaces = PassthroughSubject<Void, Never>()
    fileprivate let _showRankingPlaces = PassthroughSubject<Void, Never>()
    
    var showWeeklyPlaces: AnyPublisher<Void, Never> {
      _showWeeklyPlaces.eraseToAnyPublisher()
    }
    var showRankingPlaces: AnyPublisher<Void, Never> {
      _showRankingPlaces.eraseToAnyPublisher()
    }
  }
  
  let output: Output = Output()
  private var cancellables = Set<AnyCancellable>()
  
  func send(input: Input) {
    switch input {
    case .viewDidLoad:
      self.output._showWeeklyPlaces.send()
    case .selectSegment(let index):
      if index == 0 {
        self.output._showWeeklyPlaces.send()
      } else {
        self.output._showRankingPlaces.send()
      }
    }
  }
}

extension PlaceViewModel {
  
}
