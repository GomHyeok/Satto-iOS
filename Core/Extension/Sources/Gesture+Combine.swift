//
//  Gesture+Combine.swift
//  Extension
//
//  Created by ttozzi on 8/6/25.
//

import UIKit
import Combine

private final class GesturePublisher: Publisher {
  typealias Output = UIGestureRecognizer
  typealias Failure = Never
  
  private let view: UIView
  private let gestureRecognizer: UIGestureRecognizer
  
  init(view: UIView, gestureRecognizer: UIGestureRecognizer) {
    self.view = view
    self.gestureRecognizer = gestureRecognizer
  }
  
  func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
    let subscription = GestureSubscription(
      subscriber: subscriber,
      view: view,
      gestureRecognizer: gestureRecognizer
    )
    subscriber.receive(subscription: subscription)
  }
}

private final class GestureSubscription<S: Subscriber>: Subscription where S.Input == UIGestureRecognizer {
  
  private var subscriber: S?
  private weak var view: UIView?
  private let gestureRecognizer: UIGestureRecognizer
  
  init(subscriber: S, view: UIView, gestureRecognizer: UIGestureRecognizer) {
    self.subscriber = subscriber
    self.view = view
    self.gestureRecognizer = gestureRecognizer
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(gestureRecognizer)
    gestureRecognizer.addTarget(self, action: #selector(handleGesture))
  }
  
  func request(_ demand: Subscribers.Demand) { }
  
  func cancel() {
    subscriber = nil
    gestureRecognizer.removeTarget(self, action: #selector(handleGesture))
  }
  
  @objc private func handleGesture() {
    _ = subscriber?.receive(gestureRecognizer)
  }
}

public extension UIView {
  func gesturePublisher<T: UIGestureRecognizer>(gestureRecognizer: T) -> AnyPublisher<UIGestureRecognizer, Never> {
    return GesturePublisher(view: self, gestureRecognizer: gestureRecognizer).eraseToAnyPublisher()
  }
}
