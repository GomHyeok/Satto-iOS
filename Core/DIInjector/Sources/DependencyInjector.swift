//
//  DependencyInjector.swift
//  CoreLayer
//
//  Created by 최재혁 on 7/21/25.
//

import Foundation
import Swinject

@propertyWrapper
public final class Injected<T> {
  public let wrappedValue: T

  public init() {
    self.wrappedValue = DependencyInjector.shared.resolve(T.self)
  }
}

// DI 대상 등록
public protocol DependencyAssemblable {
  func assemble(_ assemblyList: [Assembly])
  func register<T>(_ serviceType: T.Type, factory: @escaping (Resolver) -> T)
}

// DI 등록한 서비스 사용
public protocol DependencyResolvable {
  func resolve<T>(_ serviceType: T.Type) -> T
}

public typealias Injector = DependencyAssemblable & DependencyResolvable

public final class DependencyInjector: Injector {
  private let container: Container = Container()

  public static let shared = DependencyInjector()

  private init() {}

  public func assemble(_ assemblyList: [any Assembly]) {
    assemblyList.forEach {
      $0.assemble(container: container)
    }
  }

  public func register<T>(_ serviceType: T.Type, factory: @escaping (Resolver) -> T) {
    container.register(serviceType, factory: factory)
  }

  public func resolve<T>(_ serviceType: T.Type) -> T {
    container.resolve(serviceType)!
  }
}
