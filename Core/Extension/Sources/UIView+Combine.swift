//
//  UIView+Combine.swift
//  CoreLayer
//
//  Created by 최재혁 on 7/25/25.
//

import Combine
import UIKit

extension UIControl {
  //주어진 이벤트에 대한 Publisher 반환(EventPublisher)
  func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
    .init(control: self, event: event)
  }

  //UIControl객체와 이벤트 전달
  struct EventPublisher: Publisher {
    typealias Output = UIControl
    typealias Failure = Never

    let control: UIControl
    let event: UIControl.Event

    //Subscrier가 구독 시작시 호출
    func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, UIControl == S.Input {
      let subscription = EventSubscription(control: control, subscrier: subscriber, event: event)
      subscriber.receive(subscription: subscription)
    }
  }

  //이벤트 발생할 때마다 구독자에게 이벤트 전달
  fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription
  where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {

    //control과 event를 통해 특정 이벤트를 수신할 수 있도록 설정
    weak var control: UIControl?
    let event: UIControl.Event
    var subscriber: EventSubscriber?

    init(control: UIControl, subscrier: EventSubscriber, event: UIControl.Event) {
      self.control = control
      self.subscriber = subscrier
      self.event = event

      control.addTarget(self, action: #selector(handleEvent), for: event)
    }

    func request(_ demand: Subscribers.Demand) {}

    //구독을 취소할 때 호출
    func cancel() {
      subscriber = nil
      control?.removeTarget(self, action: #selector(handleEvent), for: event)
    }

    //이벤트 발생 시 호출되는 함수 -> 구독자에게 UIControl 전달하여 이벤트 발생했음을 알림
    @objc func handleEvent() {
      guard let control = control else { return }
      _ = subscriber?.receive(control)
    }
  }
}

extension UIButton {
  public var tapPublisher: AnyPublisher<Void, Never> {
    controlPublisher(for: .touchUpInside)
      .map { _ in }
      .eraseToAnyPublisher()
  }
}

extension UISwitch {
  public var isOnPublisher: AnyPublisher<Bool, Never> {
    controlPublisher(for: .valueChanged)
      .map { [weak self] _ in self?.isOn ?? false }
      .eraseToAnyPublisher()
  }
}
