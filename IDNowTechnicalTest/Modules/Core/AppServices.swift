//
//  AppServices.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import Foundation

/// A service represents the layer between the ViewModel and the repository.
/// It is responsible of all the communication between the front layer and the IO layer (data management, API calls, native call, etc)
/// Every module of the application MUST have an A{feature}Service file that inherits Service
/// If a stubedService is needed, don't forget to add it in the static stub variable

extension DIInjector {
    struct Services {
        let treasureHuntService: ATreasureHuntService
        
        init(treasureHuntService: ATreasureHuntService) {
            self.treasureHuntService = treasureHuntService
        }
        
        static var stub: Self {
            .init(treasureHuntService: TreasureHuntServiceStub())
        }
    }
}


