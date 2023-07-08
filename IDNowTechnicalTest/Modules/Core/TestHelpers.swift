//
//  TestHelpers.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import Foundation

extension ProcessInfo {
    var isRunningTests: Bool {
        environment["XCTestConfigurationFilePath"] != nil
    }
}
