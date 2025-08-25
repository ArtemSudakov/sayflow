//
//  ViewsRouter.swift
//  sayflow
//
//  Created by Asd on 19.08.2025.
//

import SwiftUI

enum Screen: String, Codable, Hashable { case translate, langSelect}

@MainActor
final class ViewsRouter: ObservableObject {
  @Published var path: [Screen] = []

  func push(_ viewName: Screen) { path.append(viewName) }
  func push(_ viewName: [Screen]) { path.append(contentsOf: viewName) }
  func pop() { if !path.isEmpty { path.removeLast() } }
  func popToRoot() { path.removeAll() }
}
