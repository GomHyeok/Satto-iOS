/// The original source of this code is https://github.com/Moya/Moya/pull/2233.

import Foundation
import Moya

final class AsyncMoyaRequestWrapper {
  
  typealias MoyaContinuation = CheckedContinuation<Response, Error>
  
  private let performRequest: (MoyaContinuation) -> Moya.Cancellable?
  private var cancellable: Moya.Cancellable?
  
  init(_ performRequest: @escaping (MoyaContinuation) -> Moya.Cancellable?) {
    self.performRequest = performRequest
  }
  
  func perform(continuation: MoyaContinuation) {
    cancellable = performRequest(continuation)
  }
  
  func cancel() {
    cancellable?.cancel()
  }
}
