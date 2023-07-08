//
//  TreasureHunt.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 07/07/2023.
//

import Foundation

struct TreasureHuntGame: Codable, Equatable {
    var uid: UUID
    var title: String
}

extension TreasureHuntGame: Identifiable {
    var id: String { uid.uuidString }
}
