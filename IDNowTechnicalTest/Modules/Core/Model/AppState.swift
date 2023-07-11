//
//  AppState.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import Foundation

/// Store everything that needs to stay in the session of the user
/// In this technical test, we don't have a lot of things that needs to stay in the memory, but I added some "empty" objects to represents some use cases
struct AppState: Equatable {
    var session: CustomerSession?
}

/// Current session of the customer
struct CustomerSession: Equatable {
    var status: Bool/// Could be a specific object that handles all the session status of the user : connected, connecting, jwtExpired, etc
    var isConnected: Bool
    var userId: UUID?
}
