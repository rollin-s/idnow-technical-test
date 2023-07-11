//
//  TreasureHuntDetailViewScreenTest.swift
//  UnitTests
//
//  Created by sacha rollin on 09/07/2023.
//

import XCTest
import ViewInspector
@testable import IDNowTechnicalTest

final class TreasureHuntDetailViewScreenTest: XCTestCase {
    
    func test_treasureHunt_loading() {
        
        let treasureHunt = TreasureHuntGame.mockedData[0]
        
        let container = DIInjector(appState: AppState(), services:
                .mocked()
        )
        
        let sut = TreasureHuntDetailView(game: treasureHunt, viewModel: .init(container: container, statusHunt: .isLoading(last: nil, cancelBag: CancelBag())))
        let exp = sut.inspection.inspect { view in
            /// Check that we have the pretty loader
            XCTAssertNoThrow(try view.find(PrettyHorizontalLoader.self))
            XCTAssertEqual(container.appState, AppState())
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_treasureHunt_loaded() {
        let treasureHunt = TreasureHuntGame.mockedData[0]
        
        let container = DIInjector(appState: AppState(), services:
                .mocked()
        )
        
        let sut = TreasureHuntDetailView(game: treasureHunt, viewModel: .init(container: container, statusHunt: .loaded(true)))
        let exp = sut.inspection.inspect { view in
            /// Check that we DON'T have the pretty loader and that the text for the found treasure exists
            XCTAssertThrowsError(try view.find(PrettyHorizontalLoader.self))
            XCTAssertNoThrow(try view.find(text: "The treasure was found !! Congratulation")) // Could be highly improved, but that's only to show for the Technical test
            XCTAssertEqual(container.appState, AppState())
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_treasureHunt_NotFound() {
        let treasureHunt = TreasureHuntGame.mockedData[0]
        
        let container = DIInjector(appState: AppState(), services:
                .mocked()
        )
        
        let sut = TreasureHuntDetailView(game: treasureHunt, viewModel: .init(container: container, statusHunt: .loaded(false)))
        let exp = sut.inspection.inspect { view in
            /// Check that we DON'T have the pretty loader and that the text for the not found treasure exists
            /// We also check that there is the retry button
            XCTAssertThrowsError(try view.find(PrettyHorizontalLoader.self))
            XCTAssertNoThrow(try view.find(text: "You haven't found the treasure, it's gonna be lost forever now lads. Try again !!")) // Could be highly improved, but that's only to show for the Technical test
            XCTAssertNoThrow(try view.find(button: "Let's try again and read again the map")) // Same
            XCTAssertEqual(container.appState, AppState())
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
}
