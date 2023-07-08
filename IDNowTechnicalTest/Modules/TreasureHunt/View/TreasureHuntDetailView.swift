//
//  TreasureHuntDetailView.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import Foundation
import SwiftUI

struct TreasureHuntDetailView: View, Identifiable {
    var id: String { game.id }
    
    /// Current game
    let game: TreasureHuntGame
    
    @ObservedObject private(set) var viewModel: ViewModel
    
    init(game: TreasureHuntGame, viewModel: ViewModel) {
        self.game = game
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.title)
                .font(.title)
            content
        }
        .padding()
        .frame(alignment: .leading)
        .background(Color.blue)
    }
    
    
    @ViewBuilder private var content: some View {
        VStack {
            switch viewModel.statusHunt {
            case .notRequested:
                notRequestedView
            case let .isLoading(last, _):
                loadingView(last)
            case let .loaded(wasTreasureFound):
                loadedView(wasTreasureFound: wasTreasureFound)
            case let .failed(error):
                failedView(error)
            }
        }
    }
}


private extension TreasureHuntDetailView {
    /// If we want to do anything when the view is not yet requested (default value, start animation, etc) we can do it here
    var notRequestedView: some View {
        Text("").onAppear(perform: {
            viewModel.startSearchTreasure(treasureHunt: self.game)
        })
    }
    
    func loadingView(_ previouslyLoaded: Bool?) -> some View {
        return AnyView(ActivityIndicatorView().padding().background(Color.red))
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            /// No need  of an error handler for the demo purpose, but we could retry the API calls if needed
        })
    }
}

private extension TreasureHuntDetailView {
    func loadedView(wasTreasureFound: Bool) -> some View{
        if (wasTreasureFound) {
            return Text("The treasure was found !! Congratulation")
                .background(Color.green)
        }
        
        return Text("You haven't found the treasure, it's gonna be lost forever now lads")
            .background(Color.gray)
    }
}
