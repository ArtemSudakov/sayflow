//
//  AppRootView.swift
//  sayflow
//
//  Created by Asd on 19.08.2025.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject private var router: ViewsRouter

    var body: some View {
        NavigationStack(path: $router.path) {
            router.screen(for: .home) // start from home screen
                .navigationDestination(for: Screen.self) { screen in
                    router.screen(for: screen)
                }
        }
    }
}
