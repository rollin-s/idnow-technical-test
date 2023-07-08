//
//  HangedManRepository.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 07/07/2023.
//

import Foundation
import Combine

protocol TreasureHuntRepository: IDApiClientRepository {
    func createNewGame() -> AnyPublisher<TreasureHuntGame, Error>
    func waitForWin(game: TreasureHuntGame) -> AnyPublisher<Bool, Error>
}

struct ApiTreasureHuntRepository: TreasureHuntRepository {
    
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_parse_queue")
    
    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func createNewGame() -> AnyPublisher<TreasureHuntGame, Error> {
        return call(endpoint: API.createGame)
    }

    func waitForWin(game: TreasureHuntGame) -> AnyPublisher<Bool, Error> {
        return call(endpoint: API.waitForWin(game))
//        let request: AnyPublisher<Bool, Error> = call(endpoint: API.countryDetails(country))
//        return request
//            .tryMap { array -> Country.Details.Intermediate in
//                guard let details = array.first
//                    else { throw APIError.unexpectedResponse }
//                return details
//            }
//            .eraseToAnyPublisher()
    }
}

// MARK: - Endpoints

extension ApiTreasureHuntRepository {
    enum API {
        case createGame
        case waitForWin(TreasureHuntGame)
    }
}

extension ApiTreasureHuntRepository.API: APICall {
    var path: String {
        switch self {
        case .createGame:
            return "/game"
        case let .waitForWin(game):
            let encodedName = game.id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            return "/game/\(encodedName ?? "")" ///  Might want to add a fallback if a game doesn't have an ID. This shouldn't happend.
        }
    }
    var method: String {
        switch self {
        case .createGame:
            return "PUT"
        case .waitForWin(_):
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
