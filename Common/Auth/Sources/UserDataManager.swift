//
//  UserDataManager.swift
//  Auth
//
//  Created by ttozzi on 8/15/25.
//

import Base
import Combine
import DIInjector
import Foundation
import NetworkCore

public final class UserDataManager {

  public static let shared = UserDataManager()
  @Injected private var deviceUUIDManager: DeviceUUIDManager
  @Injected private var networkProvider: NetworkProvider
  public var user: UserDTO?
  public var userID: String { user?.id ?? deviceUUIDManager.deviceUUID }
  private let userPublisher: PassthroughSubject<Void, Never> = .init()

  @discardableResult
  public func fetch() async throws -> UserDTO {

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

  @discardableResult
  public func create(name: String, birthDate: String, birthTime: [String]?, gender: GenderDTO)
    async throws -> UserDTO
  {
    let userModel = UserModel(
      id: userID, name: name, birthDate: birthDate, birthTime: birthTime, gender: gender)
    let target = AuthTarget.PostUser(userModel: userModel)
    do {
      let user = try await networkProvider.request(target: target)
      self.user = user
      return user
    } catch {
      throw error
    }
  }

  @discardableResult
  public func update(name: String, birthDate: String, birthTime: [String]?, gender: GenderDTO)
    async throws -> UserDTO
  {
    let userModel = UserModel(
      id: userID, name: name, birthDate: birthDate, birthTime: birthTime, gender: gender)
    let target = AuthTarget.PutUser(userModel: userModel)
    do {
      let user = try await networkProvider.request(target: target)
      self.user = user
      userPublisher.send(())
      return user
    } catch {
      throw error
    }
  }

  public func delete() async throws {
    do {
      try deviceUUIDManager.deleteUUID()
      user = nil
    } catch {
      throw error
    }
  }

  public func getPublisher() -> AnyPublisher<Void, Never> {
    userPublisher
      .eraseToAnyPublisher()
  }
}
