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
            HomeView()
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .translate:  HomeView()
                    case .langSelect: SelectLangView()
                        
                    }
                }
        }
    }
}
