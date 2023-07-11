//
//  TreasureHuntNotStartedView.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 09/07/2023.
//

import Foundation
import SwiftUI

struct TreasureHuntNotStarted: View {
    var body: some View {
        Text("The treasure hunt haven't been started yet... Brace yourself fools")
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .padding(16)
            .foregroundColor(.white)
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 2)
            .background(
                Color.Blue.blueNotStarted
            )
            .cornerRadius(12)

    }
}
