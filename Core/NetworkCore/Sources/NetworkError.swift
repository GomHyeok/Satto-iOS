//
//  NetworkError.swift
//  NetworkCore
//
//  Created by ttozzi on 7/20/25.
//

import Foundation

public enum NetworkError: Error {
  case noInternet
  case timeout
  case serverError(statusCode: Int)
  case invalidResponse
  case decodingError
  case unknown(Error?)
}
