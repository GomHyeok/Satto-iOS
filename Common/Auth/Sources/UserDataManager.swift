//
//  UserDataManager.swift
//  Auth
//
//  Created by ttozzi on 8/15/25.
//

import Base
import DIInjector
import Foundation
import NetworkCore

public final class UserDataManager {

  public static let shared = UserDataManager()
  @Injected private var deviceUUIDManager: DeviceUUIDManager
  @Injected private var networkProvider: NetworkProvider
  public var user: UserDTO?

  @discardableResult
  public func fetch() async throws -> UserDTO {
    let userID = user?.id ?? deviceUUIDManager.deviceUUID
    let target = AuthTarget.GetUser(userID: userID)
    do {
      let user = try await networkProvider.request(target: target)
      self.user = user
      return user
    } catch {
      // TODO: 에러 처리?
      throw error
    }
  }
}
