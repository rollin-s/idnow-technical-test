//
//  HangedManRepository.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 07/07/2023.
//

import Foundation
import Combine

protocol TreasureHuntRepository: IDApiClientRepository {
    func createNewGame() -> AnyPublisher<[TreasureHuntGame], Error>
    func startSearchingTreasure(game: TreasureHuntGame) -> AnyPublisher<Bool, Error>
}

/// API example of some e
struct ApiTreasureHuntRepository: TreasureHuntRepository {
    
    let session: URLSession
    let baseURL: String
    /// Thread management for API calls. This could be highly improved, but I've added it here for and example of improvement in the demo
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func createNewGame() -> AnyPublisher<[TreasureHuntGame], Error> {
        return call(endpoint: API.createGame)
    }

    func startSearchingTreasure(game: TreasureHuntGame) -> AnyPublisher<Bool, Error> {
        return call(endpoint: API.subscribeToGame(game))
    }
}

// MARK: - Endpoints

extension ApiTreasureHuntRepository {
    enum API {
        case createGame
        case subscribeToGame(TreasureHuntGame)
    }
}

extension ApiTreasureHuntRepository.API: APICall {
    var path: String {
        switch self {
        case .createGame:
            return "/game"
        case let .subscribeToGame(game):
            let encodedName = game.uid.uuidString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            return "/game/\(encodedName ?? "")" ///  Might want to add a fallback if a game doesn't have an ID. This shouldn't happend.
        }
    }
    var method: String {
        switch self {
        case .createGame:
            return "PUT"
        case .subscribeToGame(_):
            return "GET"
        }
    }
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    func body() throws -> Data? {
        return nil
    }
}
