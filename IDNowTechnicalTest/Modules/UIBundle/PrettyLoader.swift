//
//  PrettyLoader.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 08/07/2023.
//

import SwiftUI

struct PrettyHorizontalLoaderStyle: ProgressViewStyle {
    let colorLoader: Color
    
    init(colorLoader: Color = Color.Brown.brownDiggin) {
        self.colorLoader = colorLoader
    }

    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                
                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
                    .foregroundColor(colorLoader)
                    .animation(.linear)
            }
            .cornerRadius(10)
        }
    }
}

struct PrettyHorizontalLoader: View {
    @State private var searchedAmount = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        ProgressView("Searching the treasure...", value: searchedAmount, total: 200)
            .progressViewStyle(PrettyHorizontalLoaderStyle())
            .onReceive(timer) { _ in
                if searchedAmount < 200 {
                    searchedAmount += 2
                } else {
                    searchedAmount = 0
                }
            }
    }
}
