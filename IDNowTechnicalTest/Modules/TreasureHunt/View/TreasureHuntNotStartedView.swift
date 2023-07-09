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
        Text("The treasure hunt haven't been started yet... Brace yourself fols")
            .padding(16)
            .frame(alignment: .center)
            .foregroundColor(.indigo)// We don't need any NotRequestView in our case, but might be usefull if we have a list loader first

    }
}
