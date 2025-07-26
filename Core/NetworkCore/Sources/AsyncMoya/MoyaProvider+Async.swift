/// The original source of this code is https://github.com/Moya/Moya/pull/2233.

import Foundation
import Moya

extension MoyaProvider {
  
  func request(_ target: Target) async throws -> Response {
    let asyncRequestWrapper = AsyncMoyaRequestWrapper { [weak self] continuation in
      guard let self else {
        continuation.resume(throwing: NetworkError.unknown(nil))
        return nil
      }
      return self.request(target) { result in
        switch result {
        case .success(let response):
          continuation.resume(returning: response)
        case .failure(let moyaError):
          continuation.resume(throwing: moyaError)
        }
      }
    }
    
    return try await withTaskCancellationHandler(operation: {
      try await withCheckedThrowingContinuation({ continuation in
        asyncRequestWrapper.perform(continuation: continuation)
      })
    }, onCancel: {
      asyncRequestWrapper.cancel()
    })
  }
}
