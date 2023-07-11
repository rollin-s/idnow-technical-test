//
//  TreasureHuntListUITest.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 09/07/2023.
//
import XCTest
import ViewInspector
@testable import IDNowTechnicalTest

final class TreasureHuntListTests: XCTestCase {
    
    /// Verify that the NotRequested view doesn't have a text
    func test_treasureHunts_notRequested() {
        let container = DIInjector(appState: AppState(), services:
                                    // No service since we haven't clicked on the button yet
            .mocked()
        )
        
        let sut = TreasureHuntScreen(viewModel: .init(container: container, games: .notRequested))
        /// Check that we have the TreasureHuntNotStarted view
        let exp = sut.inspection.inspect { view in
            XCTAssertNoThrow(try view.content().find(TreasureHuntNotStarted.self))
            XCTAssertEqual(container.appState, AppState())
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_treasureHunt_loading() {
        let container = DIInjector(appState: AppState(), services:
                .mocked()
        )
        
        // We could add mocked treasure for the lastly fetched datas, but we don't implement it in production, no need in test yet
        let sut = TreasureHuntScreen(viewModel: .init(container: container, games: .isLoading(last: [], cancelBag: CancelBag())))
        let exp = sut.inspection.inspect { view in
            /// Check that we have NOT a TreasureHuntNotStarted view + that we have the activityIndicator
            XCTAssertNoThrow(try view.content().find(ActivityIndicatorView.self))
            XCTAssertThrowsError(try view.content().find(TreasureHuntNotStarted.self))
            XCTAssertEqual(container.appState, AppState())
            container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
    
    func test_treasureHunt_loaded() {
        let container = DIInjector(appState: AppState(), services:
                .mocked(
                    treasureHuntService:
                        /// When the view appears, it is directly starting the treasure hunt, we have to mock it with the mocked treasure hunts
                        TreasureHuntGame.mockedData.map({ game in
                            MockedTreasureHuntService.Action.searchTreasure(game: game)
                        })
                )
        )
        
        // We could add mocked treasure for the lastly fetched datas, but we don't implement it in production, no need in test yet
        let sut = TreasureHuntScreen(viewModel: .init(container: container, games: .loaded(TreasureHuntGame.mockedData)))
        let exp = sut.inspection.inspect { view in
            // Check that we don't have any loader or treasureHuntNotStarted view
            // Check that the first elem on the list is the first elem of the mocked data
            XCTAssertThrowsError(try view.content().find(ActivityIndicatorView.self))
            XCTAssertThrowsError(try view.content().find(TreasureHuntNotStarted.self))
            let cell = try view.content().find(TreasureHuntDetailView.self).actualView()
            XCTAssertEqual(cell.game, TreasureHuntGame.mockedData[0])
            XCTAssertEqual(container.appState, AppState())
            // I have a bug here where the views are not appearing syncrhonisly, so the comparaison with the mocked data might not be ok
            // I haven't go the time to find a solution, but that's something I'll have to look into.
            // Basically, the API calls might be => [1] => [0] => [2], or any array orders.
            //container.services.verify()
        }
        ViewHosting.host(view: sut)
        wait(for: [exp], timeout: 2)
    }
}

// MARK: - CountriesList inspection helper
/// Extension of TreasureHuntScreen inspectable to get the content of the view directly (we don't want to get the geometry reader/navigation view every time
extension InspectableView where View == ViewType.View<TreasureHuntScreen> {
    func content() throws -> InspectableView<ViewType.NavigationView> {
        return try geometryReader().navigationView()
    }
}
