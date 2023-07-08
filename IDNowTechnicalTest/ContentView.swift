//
//  ContentView.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import SwiftUI
import Foundation

// MARK: - Base view of the application
struct ContentView: View {

    @ObservedObject private(set) var viewModel: ViewModel

    var body: some View {
        Group {
            if viewModel.isRunningTests {
                Text("Running unit tests")
            } else {
                TreasureHuntScreen(viewModel: .init(container: viewModel.container))
            }
        }
    }
}

// MARK: - ViewModel

extension ContentView {
    class ViewModel: ObservableObject {

        let container: DIInjector
        let isRunningTests: Bool

        init(container: DIInjector, isRunningTests: Bool = ProcessInfo.processInfo.isRunningTests) {
            self.container = container
            self.isRunningTests = isRunningTests
        }
    }
}
