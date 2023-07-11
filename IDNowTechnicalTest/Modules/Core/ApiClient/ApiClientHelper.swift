//
//  ApiClientHelper.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import Combine

extension Publisher {
    
    /// Whenever we have AnyPublisher that needs to wait for it's completion, we either complete the loaded value, or we complete the error
    /// This is mainly usefull to help lisibility in the ApiClients
    func sinkToLoadable(_ completion: @escaping (Loadable<Output>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { subscriptionCompletion in
            if let error = subscriptionCompletion.error {
                completion(.failed(error))
            }
        }, receiveValue: { value in
            completion(.loaded(value))
        })
    }
}

extension Subscribers.Completion {
    /// Improve lisibility to catch the errors on the completion of the subscriptions.
    /// Mainly usefull to help lisibility in the ApiClients
    var error: Failure? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}
