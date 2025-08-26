//
//  DIContainer.swift
//  SayFlow
//
//  Created by Asd on 26.08.2025.
//

import SwiftUI

final class DIContainer {
    func makeHomeScreen(router: ViewsRouter) -> AnyView {
        let vm = HomeViewModel(router: router)
        return AnyView(HomeView(vm: vm))
    }
}
