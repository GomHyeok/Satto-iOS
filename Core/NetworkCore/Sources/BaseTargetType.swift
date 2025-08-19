//
//  BaseTargetType.swift
//  NetworkCore
//
//  Created by ttozzi on 7/24/25.
//

import Foundation
import Moya

public typealias HTTPTask = Moya.Task
public typealias HTTPMethod = Moya.Method

public protocol BaseTargetType<Response>: TargetType {

  associatedtype Response: Decodable

  var httpTask: HTTPTask { get }
  var httpMethod: HTTPMethod { get }
}

extension BaseTargetType {
  public var baseURL: URL {
    return URL(string: "https://www.satto.io.kr/api/v1")!
  }
  public var task: Moya.Task { httpTask }
  public var method: Moya.Method { httpMethod }
  public var validationType: ValidationType { .successCodes }
}
