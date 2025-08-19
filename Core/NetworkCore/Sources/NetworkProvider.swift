//
//  NetworkProvider.swift
//  NetworkCore
//
//  Created by ttozzi on 7/20/25.
//

import Foundation
import Moya

public final class NetworkProvider {

  public static let shared = NetworkProvider()
  private let internalProvider: MoyaProvider<MultiTarget>

  private init() {
    let configuration = URLSessionConfiguration.default
    configuration.timeoutIntervalForRequest = DefaultConfig.timeOutInterval
    configuration.timeoutIntervalForResource = DefaultConfig.timeOutInterval
    let session = Session(configuration: configuration, interceptor: RetryInterceptor())
    self.internalProvider = MoyaProvider<MultiTarget>(session: session)
  }

  public func request<T: BaseTargetType>(target: T) async throws -> T.Response {
    // TODO: Reachability 확인 필요할지
    do {
      let responseData = try await internalProvider.request(MultiTarget(target))
      let response = try JSONDecoder().decode(T.Response.self, from: responseData.data)
      return response
    } catch {
      throw mapToNetworkError(error)
    }
  }

  private func mapToNetworkError(_ error: Error) -> NetworkError {
    if let moyaError = error as? MoyaError {
      switch moyaError {
      case .underlying(let nsError as NSError, _):
        if nsError.domain == NSURLErrorDomain {
          switch nsError.code {
          case NSURLErrorNotConnectedToInternet:
            return .noInternet
          case NSURLErrorTimedOut:
            return .timeout
          default:
            return .unknown(nsError)
          }
        } else {
          return .unknown(nsError)
        }
      case .statusCode(let response):
        return .serverError(statusCode: response.statusCode)
      case .requestMapping, .parameterEncoding, .objectMapping, .encodableMapping:
        return .invalidResponse
      default:
        return .unknown(moyaError)
      }
    } else if error is DecodingError {
      return .decodingError
    } else {
      return .unknown(error)
    }
  }
}
