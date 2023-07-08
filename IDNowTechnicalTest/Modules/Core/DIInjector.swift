//
//  DIInjector.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import SwiftUI
import Combine

/// Dependency Injector of the application
/// Store a appState object that store all the information we want to keep in the global state of the application
/// Store a Services that represents all the services of the application.
///
struct DIInjector: EnvironmentKey {
    
    let appState: AppState
    let services: Services
    
    static var defaultValue: Self { Self.default }
    
    private static let `default` = DIInjector(appState: AppState(), services: .stub)
    
    init(appState: AppState, services: DIInjector.Services) {
        self.appState = appState
        self.services = services
    }
}

#if DEBUG
extension DIInjector {
    static var preview: Self {
        .init(appState: AppState(), services: .stub)
    }
}
#endif
