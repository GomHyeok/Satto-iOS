//
//  AuthTarget.swift
//  Lib
//
//  Created by ttozzi on 8/15/25.
//

import Base
import Foundation
import NetworkCore

enum AuthTarget {

  struct GetUser: BaseTargetType {

    typealias Response = UserDTO

    var path: String { "users/\(userID)" }
    var httpTask: HTTPTask { .requestPlain }
    var httpMethod: HTTPMethod { .get }
    var headers: [String: String]? { nil }
    let userID: String
  }

  struct PostUser: BaseTargetType {
    typealias Response = UserDTO

    var path: String { "/users" }
    var httpTask: HTTPTask { .requestJSONEncodable(userModel) }
    var httpMethod: HTTPMethod { .post }
    var headers: [String: String]? {
      ["Content-Type": "application/json"]
    }

    let userModel: UserModel
  }

  struct PutUser: BaseTargetType {
    typealias Response = UserDTO

    var path: String { "users/\(userModel.id)" }
    var httpTask: HTTPTask { .requestJSONEncodable(userModel) }
    var httpMethod: HTTPMethod { .put }
    var headers: [String: String]? {
      ["Content-Type": "application/json"]
    }

    let userModel: UserModel
  }
}
