//
//  TreasureHuntDetailView.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import Foundation
import SwiftUI

struct TreasureHuntDetailView: View {
    
    let game: TreasureHuntGame
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(game.title)
                .font(.title)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
    }
}
