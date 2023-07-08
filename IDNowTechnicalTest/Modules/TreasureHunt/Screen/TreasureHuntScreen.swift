//
//  TreasureHuntScreen.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import SwiftUI
import Combine

/// Treasure hunt screen
/// you can create a treasure Hunt, and you will find a treasure after a random amount of time between 1s and 15s.
/// 
struct TreasureHuntScreen: View {
    
    @ObservedObject private(set) var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            self.content
                .navigationBarTitle("Treasure Hunt")
                .animation(.easeOut(duration: 0.3))
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
    @ViewBuilder private var content: some View {
        VStack {
            switch viewModel.games {
            case .notRequested:
                notRequestedView
            case let .isLoading(last, _):
                loadingView(last)
            case let .loaded(countries):
                loadedView(countries, showLoading: false)
            case let .failed(error):
                failedView(error)
            }
            Spacer()
            Button("Create a new treasure hunt") {
                viewModel.createNewGame()
            }
        }
    }
}

// MARK: - Loading Content

private extension TreasureHuntScreen {
    var notRequestedView: some View {
        Text("") // We don't need any NotRequestView in our case, but might be usefull if we have a list loader first
    }
    
    func loadingView(_ previouslyLoaded: [TreasureHuntGame]?) -> some View {
        return AnyView(ActivityIndicatorView().padding())
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            /// No need  of an error handler for the demo purpose, but we could retry the API calls if needed
        })
    }
}

// MARK: - Displaying Content

private extension TreasureHuntScreen {
    func loadedView(_ games: [TreasureHuntGame], showLoading: Bool) -> some View {
        VStack {
            if showLoading {
                ActivityIndicatorView().padding()
            }
            List(games) { game in
                TreasureHuntDetailView(
                    game: game,
                    viewModel: .init(
                        container: viewModel.container
                    )
                )
                .padding(4)
            }
            .padding(12)
        }
    }
}

// MARK: - Preview

#if DEBUG
struct TreasureHuntScreen_Previews: PreviewProvider {
    static var previews: some View {
        TreasureHuntScreen(viewModel: .init(container: .preview))
    }
}
#endif
