//
//  ViewStatus.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import Foundation

enum ViewStatus<T> {
    case loading
    case success(data: T)
    case error(e: Error)
}
