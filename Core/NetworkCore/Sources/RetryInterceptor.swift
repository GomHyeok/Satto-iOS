//
//  RetryInterceptor.swift
//  NetworkCore
//
//  Created by ttozzi on 8/20/25.
//

import Alamofire
import Foundation
import Moya

final class RetryInterceptor: RequestInterceptor {
  
  private let retryLimit = DefaultConfig.retryLimit

  func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
    let retryCount = request.retryCount
    if retryCount < retryLimit {
      completion(.retryWithDelay(1 * pow(2, Double(retryCount))))
    } else {
      completion(.doNotRetry)
    }
  }
}
