//
//  ViewInspectionHelper.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 09/07/2023.
//

import Combine

// MARK: - View Inspection helper
/// Mainly used to help broadcast views to the unit tests
internal final class Inspection<V> {
    let notice = PassthroughSubject<UInt, Never>()
    var callbacks = [UInt: (V) -> Void]()
    
    func visit(_ view: V, _ line: UInt) {
        if let callback = callbacks.removeValue(forKey: line) {
            callback(view)
        }
    }
}
