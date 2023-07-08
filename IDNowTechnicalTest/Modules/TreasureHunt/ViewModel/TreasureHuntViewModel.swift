//
//  TreasureHuntViewModel.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import Foundation

/// View model of the treasure hunt
extension TreasureHuntScreen {
    class ViewModel: ObservableObject {
        
        // State
        @Published var games: Loadable<[TreasureHuntGame]>
        @Published var canRequestPushPermission: Bool = false        
    
        // Misc
        let container: DIInjector
        
        init(container: DIInjector, games: Loadable<[TreasureHuntGame]> = .notRequested) {
            self.container = container
            _games = .init(initialValue: games)
        }
        
        // MARK: - Side Effects
        
        /// Create a new game and add it in the games array
        func createNewGame() {
            container
                .services
                .treasureHuntService
                .createNewGame(games: loadableSubject(\.games))
        }
    }
}
