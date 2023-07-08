//
//  HangedManService.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import Foundation

protocol ATreasureHuntService {
    func newTreasureHunt()
}

/// Production HangedMan Service
/// Communicate with the API
class TreasureHuntService: ATreasureHuntService {
    let webRepository: TreasureHuntRepository
    let appState:AppState
    
    init(webRepository: TreasureHuntRepository, appState: AppState) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    func newTreasureHunt() {
    }
}

/// Stub response of the Treasure Hunt game
///
class TreasureHuntServiceStub: ATreasureHuntService {
    func newTreasureHunt() {
        // Add
    }
    
    
}
