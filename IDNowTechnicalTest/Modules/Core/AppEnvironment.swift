//
//  AppModules.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import Foundation


/// Representation of the current environement of the application
/// We might want to add specific build environements separation (dev, prod, preprod, etc)
/// We could override them with some .plist at the start of the application
struct AppEnvironment {
    let container: DIInjector
}

extension AppEnvironment {
    
    static func startApp() -> AppEnvironment {
        let appState = AppState()
        let session = configuredURLSession()
        let webRepositories = configuredFakeWebRepositories(session: session)
        let services = configuredServices(appState: appState,
                                                webRepositories: webRepositories)
        let diContainer = DIInjector(appState: appState, services: services)
        return AppEnvironment(container: diContainer)
    }
    
    private static func configuredURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    /// Configure all the web API needed and return add them in the DIInjector
    /// Not used on the demo but I added it to add comprehension
    private static func configuredWebRepositories(session: URLSession) -> DIInjector.WebRepositories {
        let treasureHuntWebRepository = ApiTreasureHuntRepository(
            session: session,
            baseURL: "https://my.treasure.api.com/v2")
        return .init(treasureHuntRepository: treasureHuntWebRepository)
    }
    
    /// Create the fake web repositories for the technical test.
    /// We only have one API, but we can add as much as needed
    private static func configuredFakeWebRepositories(session: URLSession) -> DIInjector.WebRepositories {
        let fakeTreasureHuntWebRepository = FakeTreasureHuntRepository  (
            session: session,
            baseURL: "notUsedOnDemo")
        return .init(treasureHuntRepository: fakeTreasureHuntWebRepository)
    }
    
    
    /// Configure all the services of the application.
    /// If you add a new module, don't forget to add the service in here
    private static func configuredServices(appState: AppState,
                                           webRepositories: DIInjector.WebRepositories
    ) -> DIInjector.Services {
        
        let treasureHuntService = TreasureHuntService(
            webRepository: webRepositories.treasureHuntRepository,
            appState: appState
        )
        
        return .init(treasureHuntService: treasureHuntService)
    }
}

extension DIInjector {
    struct WebRepositories {
        let treasureHuntRepository: TreasureHuntRepository
    }
}
