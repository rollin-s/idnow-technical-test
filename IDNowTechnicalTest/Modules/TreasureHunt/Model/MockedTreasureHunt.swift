//
//  MockedTreasureHunt.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 09/07/2023.
//

import Foundation

extension TreasureHuntGame {
    static let mockedData: [TreasureHuntGame] = [
        TreasureHuntGame(uid: UUID.init(), title: "Barbe noire"),
        TreasureHuntGame(uid: UUID.init(), title: "Barbe rousse"),
        TreasureHuntGame(uid: UUID.init(), title: "Barbe rouge"),
    ];
}
