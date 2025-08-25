//
//  SayFlowApp.swift
//  SayFlow
//
//  Created by Asd on 20.08.2025.
//

import SwiftUI

@main
struct SayFlowApp: App {
    @StateObject private var router = ViewsRouter()
    
    var body: some Scene {
        WindowGroup {
            AppRootView()
              .environmentObject(router)
        }
    }
}
