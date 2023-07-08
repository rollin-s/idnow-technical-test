//
//  HangedManService.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import Foundation

protocol ATreasureHuntService {
    func createNewGame(games: LoadableSubject<[TreasureHuntGame]>)
    func searchTreasure(gameToSearch: TreasureHuntGame, bindingGame: LoadableSubject<Bool>)
}

/// Production HangedMan Service
/// Communicate with the API
class TreasureHuntService: ATreasureHuntService {
    let webRepository: TreasureHuntRepository
    let appState: AppState
    
    /// On this demo, I won't bother with database or in device storage, I'll keep the current list of the treasure Hunts in the Service
    /// this could be highly improved with some DB management, device storage, cache (API side or client side), etc
    var treasureHuntGames: [TreasureHuntGame] = []
    
    init(webRepository: TreasureHuntRepository, appState: AppState) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    /// Create a new treasure Hunt game
    func createNewGame(games: LoadableSubject<[TreasureHuntGame]>) {
        let cancelBag = CancelBag()
        
        /// Add a cancelBag to a loader state if the front wants to cancel it later
        games.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        // For this technical test, I won't bother with DB or in-device storage, but all our memory/cache management can be done here
        // Right now this function might be small, but there is not a lot of complexity
        
        self.webRepository
            .createNewGame()
            // In the FakeTreasureRepository, I published the data after X seconds on the main thread
            // We could use a threadManager, but might be overkill for the demo
            .subscribe(on: DispatchQueue.main)
            .sinkToLoadable({
                games.wrappedValue = $0
            })
            .store(in: cancelBag)
    }
    
    func searchTreasure(gameToSearch: TreasureHuntGame, bindingGame: LoadableSubject<Bool>) {
        let cancelBag = CancelBag()
        
        bindingGame.wrappedValue.setIsLoading(cancelBag: cancelBag)
        
        self.webRepository
            .startSearchingTreasure(game: gameToSearch)
            .subscribe(on: DispatchQueue.main)
            .sinkToLoadable {
                bindingGame.wrappedValue = $0
            }
            .store(in: cancelBag)
    }
}

/// Stub response of the Treasure Hunt game
///
class TreasureHuntServiceStub: ATreasureHuntService {
    func createNewGame(games: LoadableSubject<[TreasureHuntGame]>) {}
    func searchTreasure(gameToSearch: TreasureHuntGame, bindingGame: LoadableSubject<Bool>) {}
}
