//
//  ViewsRouter.swift
//  sayflow
//
//  Created by Asd on 19.08.2025.
//

import SwiftUI

@MainActor
final class ViewsRouter: ObservableObject {
    @Published var path: [Screen] = []

    private var cache: [Screen: AnyView] = [:]
    private let di: DIContainer

    init(di: DIContainer) {
        self.di = di
    }

    func push(_ screen: Screen) { path.append(screen) }

    func push(_ screens: [Screen]) { path.append(contentsOf: screens) }

    func pop() { _ = path.popLast() }

    func popToRoot() { path.removeAll() }

    func screen(for screen: Screen) -> AnyView {
        if let cached = cache[screen] { return cached }

        let newView: AnyView
        switch screen {
            case .home: newView = di.makeHomeScreen(router: self)
        }
        cache[screen] = newView
        return newView
    }
}
