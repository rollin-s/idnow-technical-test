//
//  HangedManService.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import Foundation

protocol ATreasureHuntService {
    func createNewGame(games: LoadableSubject<[TreasureHuntGame]>)
}

/// Production HangedMan Service
/// Communicate with the API
class TreasureHuntService: ATreasureHuntService {
    let webRepository: TreasureHuntRepository
    let appState:AppState
    
    
    /// On this demo, I won't bother with database or in device storage, I'll keep the current list of the treasure Hunts in the Service
    /// this could be highly improved with some DB management, device storage, cache (API side or client side), etc
    var treasureHuntGames: [TreasureHuntGame] = []
    
    init(webRepository: TreasureHuntRepository, appState: AppState) {
        self.webRepository = webRepository
        self.appState = appState
    }
    
    func createNewGame(games: LoadableSubject<[TreasureHuntGame]>) {
        let cancelBag = CancelBag()
        
        games.wrappedValue.setIsLoading()
        
        // For this technical test, I won't bother with DB or in-device storage, but all our memory/cache management can be done here
        // Right now this function might be small, but there is not a lot of complexity
        
        self.webRepository
            .createNewGame()
            .subscribe(on: DispatchQueue.main)
            .sink(receiveCompletion: { value in
                print("value  received \(value)")
                if (value is Error) {
                    games.wrappedValue = .failed(value as! Error)
                }
            }, receiveValue: { newGame in
                print("New Game received \(newGame)")
                self.treasureHuntGames.append(newGame)
                
                games.wrappedValue = .loaded(self.treasureHuntGames)
            })
            .store(in: cancelBag)
    }
}

/// Stub response of the Treasure Hunt game
///
class TreasureHuntServiceStub: ATreasureHuntService {
    func createNewGame(games: LoadableSubject<[TreasureHuntGame]>) {}
}
