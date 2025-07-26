//
//  BaseTargetTyoe.swift
//  NetworkCore
//
//  Created by ttozzi on 7/24/25.
//

import Foundation
import Moya

public protocol BaseTargetType<Response>: TargetType {
  associatedtype Response: Decodable
}

extension BaseTargetType {
  public var baseURL: URL {
    return URL(string: "https://satto.io.kr")!  // TODO: 수정 필요
  }
}
