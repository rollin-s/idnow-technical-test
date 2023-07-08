//
//  Optional+Extension.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import Foundation

/// Unwrap Optional value if it exists.
/// If the value doesn't exist, throw a ValueIsMissingError
/// This might be usefull when we want to force unwrap Optionnal and catch a specific error if it is nullable
extension Optional: SomeOptional {
    func unwrap() throws -> Wrapped {
        switch self {
        case let .some(value): return value
        case .none: throw ValueIsMissingError()
        }
    }
}

struct ValueIsMissingError: Error {
    var localizedDescription: String {
        NSLocalizedString("Data is missing", comment: "")
    }
}

