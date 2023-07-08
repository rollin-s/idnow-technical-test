//
//  TreasureHuntDetailViewModel.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import Foundation

extension TreasureHuntDetailView {
    class ViewModel: ObservableObject {
        
        // State
        /// Whenever the treasure is found, the loadable will be returning true
        @Published var statusHunt: Loadable<Bool>
        
        // Misc
        let container: DIInjector
        
        init(container: DIInjector, statusHunt: Loadable<Bool> = .notRequested) {
            self.container = container
            _statusHunt = .init(initialValue: statusHunt)
        }
        
        func startSearchTreasure(treasureHunt: TreasureHuntGame) {
            container
                .services
                .treasureHuntService
                .searchTreasure(gameToSearch: treasureHunt, bindingGame: loadableSubject(\.statusHunt))
        }
    }
}
