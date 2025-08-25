//
//  CustomComponents.swift
//  sayflow
//
//  Created by Asd on 17.08.2025.
//

import SwiftUI

struct GrowingTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var measuredHeight: CGFloat
    
    var fontSize: CGFloat
    var minHeight: CGFloat
    var maxHeight: CGFloat
    var isEditable: Bool = true
    var isSelectable: Bool = true
    var textColor: UIColor = UIColor.label.withAlphaComponent(0.6)
    var contentInset: UIEdgeInsets = .init(top: 8, left: 14, bottom: 8, right: 14)
    var weight: UIFont.Weight = .regular
    var autoScrollToBottomOnChange: Bool = false
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: GrowingTextView
        init(_ parent: GrowingTextView) { self.parent = parent }
        
        func textViewDidChange(_ tv: UITextView) {
            parent.text = tv.text
            GrowingTextView.recalcHeight(tv, minH: parent.minHeight, maxH: parent.maxHeight) { [weak self] h in
                guard let self else { return }
                if self.parent.measuredHeight != h {
                    self.parent.measuredHeight = h
                }
            }
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.delegate = context.coordinator
        tv.backgroundColor = .clear
        tv.textContainerInset = contentInset
        tv.textContainer.lineFragmentPadding = 0
        tv.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        tv.keyboardDismissMode = .interactive
        tv.isScrollEnabled = false
        tv.textColor = textColor
        tv.font = .systemFont(ofSize: fontSize, weight: weight)
        return tv
    }
    
    func updateUIView(_ tv: UITextView, context: Context) {
            let textChanged = (tv.text != text)
            if textChanged { tv.text = text }

            tv.font = .systemFont(ofSize: fontSize, weight: weight)
            tv.isEditable = isEditable
            tv.isSelectable = isSelectable
            tv.textColor = textColor
            tv.textContainerInset = contentInset

            Self.recalcHeight(tv, minH: minHeight, maxH: maxHeight) { [self, weak tv] h in
                if self.measuredHeight != h { self.measuredHeight = h }

                // Автопрокрутка вниз после обновления текста и высоты
                guard textChanged, self.autoScrollToBottomOnChange, let tv else { return }

                let visibleH = tv.bounds.height - tv.adjustedContentInset.top - tv.adjustedContentInset.bottom
                let contentH = tv.contentSize.height
                guard contentH > visibleH else { return } // если всё помещается — не скроллим

                let y = max(0, contentH - visibleH)       // нижний край
                tv.setContentOffset(CGPoint(x: 0, y: y), animated: true)
                // Альтернатива: tv.scrollRangeToVisible(NSRange(location: tv.text.count, length: 0))
            }
        }
    
    // Переименовали параметры, чтобы не затмевать min()/max()
    private static func recalcHeight(_ tv: UITextView,
                                     minH: CGFloat,
                                     maxH: CGFloat,
                                     set: @escaping (CGFloat)->Void) {
        // Убеждаемся, что есть валидная ширина
        let width = max(1, tv.bounds.width)
        let target = tv.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        
        var h = Swift.max(minH, target.height)
        h = Swift.min(maxH, h)
        
        let shouldScroll = target.height > maxH - 0.5
        if tv.isScrollEnabled != shouldScroll { tv.isScrollEnabled = shouldScroll }
        
        DispatchQueue.main.async { set(h) }
    }
}







// Читаем доступную ширину, не влияя на лэйаут
private struct WidthKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { value = nextValue() }
}
private struct WidthReader: View {
    @Binding var width: CGFloat
    var body: some View {
        GeometryReader { proxy in
            Color.clear.preference(key: WidthKey.self, value: proxy.size.width)
        }
        .onPreferenceChange(WidthKey.self) { width = $0 }
    }
}

struct AutoGrowShrinkTextEditor: View {
    @Binding var text: String

    var placeholder: String? = nil
    var minHeight: CGFloat = 64
    var maxHeight: CGFloat = 160
    var fontRange: ClosedRange<CGFloat> = 16...28   // min...max
    var weight: UIFont.Weight = .regular
    var isEditable: Bool = true
    var isSelectable: Bool = true
    var autoScrollToBottomOnChange: Bool = false  
    var contentInset: UIEdgeInsets = .init(top: 8, left: 14, bottom: 8, right: 14)
    var shrinkExponent: Double = 2     // 2 ≈ медленнее вдвое; больше — ещё медленнее
    var shrinkDelay: CGFloat = 0       // 0.15 = начнёт уменьшать после 15% заполнения


    @State private var measuredHeight: CGFloat = 0      // от UITextView
    @State private var displayHeight: CGFloat = 0       // сглаженная высота
    @State private var availableWidth: CGFloat = 0      // ширина контейнера

    private var currentFont: CGFloat {
        let width = max(1, availableWidth)
        let hAtMax = measureHeight(text: text, width: width, font: fontRange.upperBound)

        let fill = clamp((hAtMax - minHeight) / (maxHeight - minHeight), 0, 1) // 0...1
        let delayed = clamp((fill - shrinkDelay) / (1 - shrinkDelay), 0, 1)    // с задержкой старта
        let eased = pow(Double(delayed), shrinkExponent)                        // замедление

        return fontRange.upperBound - CGFloat(eased) * (fontRange.upperBound - fontRange.lowerBound)
    }


    var body: some View {
        ZStack(alignment: .topLeading) {
            if let placeholder, text.isEmpty {
                Text(placeholder)
                    .foregroundColor(.black.opacity(0.5))
                    .font(.system(size: fontRange.upperBound, weight: .bold))
                    .padding(.horizontal, 14).padding(.top, 8)
            }

            GrowingTextView(
                text: $text,
                measuredHeight: $measuredHeight,
                fontSize: currentFont,
                minHeight: minHeight,
                maxHeight: maxHeight,
                isEditable: isEditable,
                isSelectable: isSelectable,
                textColor: UIColor.label.withAlphaComponent(0.6),
                contentInset: contentInset,
                weight: weight,
                autoScrollToBottomOnChange: autoScrollToBottomOnChange
            )
            .frame(height: displayHeight == 0 ? minHeight : displayHeight)
            .background(Color.clear)
        }
        // читаем ширину ПОВЕРХ текущей раскладки — это не раздувает вью
        .background(WidthReader(width: $availableWidth))
        .onChange(of: measuredHeight) { newHeight in
            let target = clamp(newHeight, minHeight, maxHeight)
            if abs(target - displayHeight) > 0.8 {
                withAnimation(.easeInOut(duration: 0.18)) {
                    displayHeight = target
                }
            }
        }
        .onAppear { displayHeight = minHeight }
    }

    // MARK: - helpers
    private func measureHeight(text: String, width: CGFloat, font: CGFloat) -> CGFloat {
        let s = text.isEmpty ? " " : text
        let font = UIFont.systemFont(ofSize: font, weight: weight)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping

        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraph
        ]
        let contentWidth = max(1, width - contentInset.left - contentInset.right)
        let rect = (s as NSString).boundingRect(
            with: CGSize(width: contentWidth, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attrs,
            context: nil
        )
        return ceil(rect.height) + contentInset.top + contentInset.bottom
    }

    private func clamp<T: Comparable>(_ x: T, _ a: T, _ b: T) -> T { min(max(x, a), b) }
}
