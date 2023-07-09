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
    /// Broadcast the view to the Screen Test
    let inspection = Inspection<Self>()
    
    init(game: TreasureHuntGame, viewModel: ViewModel) {
        self.game = game
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.title)
                .font(.body)
                .frame(alignment: .center)
            content
        }
        .padding()
        .frame(alignment: .leading)
        .onReceive(inspection.notice) {inspection.visit(self, $0) }
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
        return PrettyHorizontalLoader()
            .frame(height: 24)
    }
    
    func failedView(_ error: Error) -> some View {
        ErrorView(error: error, retryAction: {
            /// No need  of an error handler for the demo purpose, but we could retry the API calls if needed
        })
    }
}

private extension TreasureHuntDetailView {
    @ViewBuilder func loadedView(wasTreasureFound: Bool) -> some View{
        /// i could create a specific view for the success/failure of the treasure, but it's getting late, and I think it's comprehensible
        if (wasTreasureFound) {
            Text("The treasure was found !! Congratulation")
                .padding(10)
                .background(Color.Green.victoryGreen)
                .cornerRadius(12)
        } else {
            VStack {
                Text("You haven't found the treasure, it's gonna be lost forever now lads. Try again !!")
                    .padding(10)
                    .background(Color.Red.redFailure)
                    .cornerRadius(12)
                
                Button(
                    "Let's try again and read again the map") {
                        viewModel.startSearchTreasure(treasureHunt: game)
                    }
                    .padding(12)
                    .cornerRadius(12)
                    .buttonStyle(GrowingButton())
                
            }
        }
    }
}
