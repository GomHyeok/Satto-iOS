//
//  KeyChainService.swift
//  Auth
//
//  Created by ttozzi on 8/15/25.
//

import Foundation
import Security

public final class KeyChainService {

  enum KeychainError: Error {
    case duplicateEntry
    case unknown(OSStatus)
    case itemNotFound
    case invalidItemFormat
    case unhandledError(status: OSStatus)
  }

  private static let service = "com.hanbang.satto"

  private static func set(_ data: Data, forKey key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
    ]

    let attributes: [String: Any] = [
      kSecValueData as String: data
    ]

    let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)

    switch status {
    case errSecSuccess:
      return
    case errSecItemNotFound:
      try add(data, forKey: key)
    default:
      throw KeychainError.unhandledError(status: status)
    }
  }

  private static func get(forKey key: String) throws -> Data {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    guard status == errSecSuccess else {
      if status == errSecItemNotFound {
        throw KeychainError.itemNotFound
      }
      throw KeychainError.unhandledError(status: status)
    }

    guard let data = result as? Data else {
      throw KeychainError.invalidItemFormat
    }

    return data
  }

  public static func remove(forKey key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
    ]

    let status = SecItemDelete(query as CFDictionary)

    guard status == errSecSuccess || status == errSecItemNotFound else {
      throw KeychainError.unhandledError(status: status)
    }
  }

  static func hasKey(_ key: String) -> Bool {
    do {
      _ = try get(forKey: key)
      return true
    } catch {
      return false
    }
  }

  private static func add(_ data: Data, forKey key: String) throws {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: service,
      kSecAttrAccount as String: key,
      kSecValueData as String: data,
    ]

    let status = SecItemAdd(query as CFDictionary, nil)

    switch status {
    case errSecSuccess:
      return
    case errSecDuplicateItem:
      throw KeychainError.duplicateEntry
    default:
      throw KeychainError.unhandledError(status: status)
    }
  }
}

extension KeyChainService {
  public static func set(_ string: String, forKey key: String) throws {
    guard let data = string.data(using: .utf8) else {
      throw KeychainError.invalidItemFormat
    }
    try set(data, forKey: key)
  }

  public static func getString(forKey key: String) throws -> String {
    let data = try get(forKey: key)
    guard let string = String(data: data, encoding: .utf8) else {
      throw KeychainError.invalidItemFormat
    }
    return string
  }
}

extension KeyChainService {
  public static func set<T: Codable>(_ object: T, forKey key: String) throws {
    let data = try JSONEncoder().encode(object)
    try set(data, forKey: key)
  }

  public static func get<T: Codable>(_ type: T.Type, forKey key: String) throws -> T {
    let data = try get(forKey: key)
    return try JSONDecoder().decode(type, from: data)
  }
}
