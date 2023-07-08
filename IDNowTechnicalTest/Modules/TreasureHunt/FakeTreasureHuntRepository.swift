//
//  FakeTreasureHuntRepository.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import Foundation
import Combine

struct FakeTreasureHuntRepository: TreasureHuntRepository {
    var session: URLSession
    var baseURL: String

    init(session: URLSession, baseURL: String) {
        self.session = session
        self.baseURL = baseURL
    }
    
    func createNewGame() -> AnyPublisher<[TreasureHuntGame], Error> {
        return RandomTreasureHuntCreationPublisher()
            .eraseToAnyPublisher()
    }
        
    
    func startSearchingTreasure(game: TreasureHuntGame) -> AnyPublisher<Bool, Error> {
        return RandomTreasureHuntSearchingPublisher()
            .eraseToAnyPublisher()
    }
}



extension FakeTreasureHuntRepository {
    /// ########### ########### ###########
    /// Treasure hunt CREATION publisher
    /// ########### ########### ###########
    struct RandomTreasureHuntCreationPublisher: Publisher {
        // I could dynamicly type a publisher, but it might be overkill
        typealias Output = [TreasureHuntGame]
        typealias Failure = Error

        func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, [TreasureHuntGame] == S.Input {
            let subscription = RandomTreasureHuntCreationSubscriber(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class RandomTreasureHuntCreationSubscriber<S: Subscriber>: Subscription where S.Input == [TreasureHuntGame], S.Failure == Error {
        private let subscriber: S
        
        init(subscriber: S) {
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            /// I could improve this with some specific threads for the Repository directly, but might be overkill for this demo.
            DispatchQueue.global().async {
                guard demand > 0 else { return }
                
                // Create X treasures game
                var treasureHunts: [TreasureHuntGame] = []
                let randomNumber = Int.random(in: 1..<5)
                
                for index in 0...randomNumber {
                    treasureHunts.append(
                        TreasureHuntGame(
                            uid: UUID.init(),
                            title: DummyDatas.dummyCaptainsName.randomElement() ?? DummyDatas.dummyCaptainsName[0]
                        )
                    )
                }
                
                let randomTime = Double.random(in: 1..<5) // Random time interval in seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + randomTime) {
                    _ = self.subscriber.receive(treasureHunts) // Emit a random TreasureHunt
                    self.subscriber.receive(completion: .finished) // Indicate completion
                }
            }
        }
        
        /// Handle cancellation if needed
        func cancel() {}
    }
    
    /// ########### ########### ###########
    /// Treasure hunt SEARCHING publisher
    /// ########### ########### ###########
    struct RandomTreasureHuntSearchingPublisher: Publisher {
        // I could dynamicly type a publisher, but it might be overkill
        typealias Output = Bool
        typealias Failure = Error

        func receive<S>(subscriber: S) where S : Subscriber, Error == S.Failure, Bool == S.Input {
            let subscription = RandomTreasureHuntSearchingSubscriber(subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
    
    private final class RandomTreasureHuntSearchingSubscriber<S: Subscriber>: Subscription where S.Input == Bool, S.Failure == Error {
        private let subscriber: S
        
        init(subscriber: S) {
            self.subscriber = subscriber
        }
        
        func request(_ demand: Subscribers.Demand) {
            /// I could improve this with some specific threads for the Repository directly, but might be overkill for this demo.
            DispatchQueue.global().async {
                guard demand > 0 else { return }
                
                // After a random time (between 5 and 25 seconds, the treasure will be found !
                let randomTime = Double.random(in: 5..<25) // Random time interval in seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + randomTime) {
                    _ = self.subscriber.receive(true) // Emit a random TreasureHunt
                    self.subscriber.receive(completion: .finished) // Indicate completion
                }
            }
        }
        
        /// Handle cancellation if needed
        func cancel() {}
    }

}

/// Dummy datas for the treasure hunts
extension FakeTreasureHuntRepository {
    struct DummyDatas {
        static let dummyCaptainsName: [String] = [
            "Magnus Stormrider",
             "Seraphina Blackwater",
             "Donovan Ironwood",
             "Isabella Crestwind",
             "Maximus Drakeheart",
             "Aurora Nightshade",
             "Octavius Stormborn",
             "Amelia Saltwater",
             "Atticus Seaflame",
             "Celeste Tempest",
             "Jasper Deepwater",
             "Lavinia Moonstone",
             "Bartholomew Starling",
             "Serenity Mistral",
             "Orion Falconcrest",
             "Ophelia Wavebreaker",
             "Caledon Stormrage",
             "Evangeline Swiftsail",
             "Thaddeus Blackbeard",
             "Lyra Mariner"
        ]
    }
}
