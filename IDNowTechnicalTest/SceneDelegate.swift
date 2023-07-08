//
//  SceneDelegate.swift
//  IDNowTechnicalTest
//
//  Created by sacha rollin on 06/07/2023.
//

import UIKit
import SwiftUI
import Combine
import Foundation


final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        let appModules = AppEnvironment.startApp()
        let defaultScreen = TreasureHuntScreen(viewModel: TreasureHuntScreen.ViewModel(container: appModules.container))
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: defaultScreen)
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
