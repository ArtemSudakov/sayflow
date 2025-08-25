//
//  ViewExtensions.swift
//  sayflow
//
//  Created by Asd on 17.08.2025.
//

import SwiftUI
import Combine

// MARK: - Edge fading mask
struct FadeEdges: ViewModifier {
    var edges: Edge.Set = [.top, .bottom]
    var length: CGFloat = 16
    
    func body(content: Content) -> some View {
        content
        // Сначала вертикальная маска (top/bottom)
            .mask {
                GeometryReader { geo in
                    let h = max(1, geo.size.height)
                    let s = min(0.5, max(0, length / h)) // доля высоты под плавный fade
                    
                    LinearGradient(stops: [
                        .init(color: edges.contains(.top) ? .clear : .black, location: 0),
                        .init(color: .black, location: edges.contains(.top) ? s : 0),
                        .init(color: .black, location: edges.contains(.bottom) ? 1 - s : 1),
                        .init(color: edges.contains(.bottom) ? .clear : .black, location: 1),
                    ], startPoint: .top, endPoint: .bottom)
                }
            }
        // Затем горизонтальная маска (leading/trailing) — по желанию
            .mask {
                GeometryReader { geo in
                    let w = max(1, geo.size.width)
                    let s = min(0.5, max(0, length / w))
                    
                    LinearGradient(stops: [
                        .init(color: edges.contains(.leading) ? .clear : .black, location: 0),
                        .init(color: .black, location: edges.contains(.leading) ? s : 0),
                        .init(color: .black, location: edges.contains(.trailing) ? 1 - s : 1),
                        .init(color: edges.contains(.trailing) ? .clear : .black, location: 1),
                    ], startPoint: .leading, endPoint: .trailing)
                }
            }
    }
}

private struct KeyboardObserver: ViewModifier {
    @Binding var isShown: Bool
    
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                isShown = true
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                isShown = false
            }
        // На всякий случай: если фрейм ушёл вниз (клава скрылась), тоже выключаем
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { note in
                guard
                    let end = (note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
                else { return }
                if end.minY >= UIScreen.main.bounds.height { isShown = false }
            }
    }
}

extension View {
    /// Плавное исчезание содержимого у выбранных краёв.
    func fadingEdges(_ edges: Edge.Set = [.top, .bottom], length: CGFloat = 16) -> some View {
        modifier(FadeEdges(edges: edges, length: length))
    }
    /// Проверка вызвана ли клавиатура 
    func keyboardVisibility(_ isShown: Binding<Bool>) -> some View {
        self.modifier(KeyboardObserver(isShown: isShown))
    }
}
