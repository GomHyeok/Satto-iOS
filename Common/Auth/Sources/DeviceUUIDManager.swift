//
//  DeviceUUIDManager.swift
//  Auth
//
//  Created by ttozzi on 8/15/25.
//

import Foundation
import Lib

final class DeviceUUIDManager {

  private enum Constant {
    static let uuidKey = "device-uuid"
  }

  static let shared = DeviceUUIDManager()
  var deviceUUID: String {
    do {
      return try KeyChainService.getString(forKey: Constant.uuidKey)
    } catch {
      let newUUID = UUID().uuidString
      try? KeyChainService.set(newUUID, forKey: Constant.uuidKey)
      return newUUID
    }
  }

  private init() {}

  func regenerateUUID() -> String {
    let newUUID = UUID().uuidString
    try? KeyChainService.set(newUUID, forKey: Constant.uuidKey)
    return newUUID
  }

  func deleteUUID() {
    try? KeyChainService.remove(forKey: Constant.uuidKey)
  }
}
