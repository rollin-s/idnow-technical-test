//
//  MockedServices.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 09/07/2023.
//

import XCTest
import SwiftUI
import Combine
import ViewInspector
@testable import IDNowTechnicalTest

extension DIInjector.Services {
    static func mocked(
        treasureHuntService: [MockedTreasureHuntService.Action] = []
    ) -> DIInjector.Services {
        .init(treasureHuntService: MockedTreasureHuntService(expected: treasureHuntService))
    }
    
    func verify(file: StaticString = #file, line: UInt = #line) {
        (treasureHuntService as? MockedTreasureHuntService)?
            .verify(file: file, line: line)
    }
}

// MARK: - CountriesService

struct MockedTreasureHuntService: Mock, ATreasureHuntService {
    
    enum Action: Equatable {
        case createNewTreasureHunt
        case searchTreasure(game: TreasureHuntGame)
    }
    
    let actions: MockActions<Action>
    
    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }
    
    func createNewGame(games: LoadableSubject<[TreasureHuntGame]>) {
        register(.createNewTreasureHunt)
    }
    
    func searchTreasure(gameToSearch: IDNowTechnicalTest.TreasureHuntGame, bindingGame: IDNowTechnicalTest.LoadableSubject<Bool>) {
        register(.searchTreasure(game: gameToSearch))
    }
}
