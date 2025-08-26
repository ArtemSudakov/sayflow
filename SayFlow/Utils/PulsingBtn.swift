import SwiftUI

struct PulsingButtonStyle: ButtonStyle {
    enum Shape {
        case circle(size: CGFloat)
        case rounded(cornerRadius: CGFloat, padding: CGFloat = 12)
    }

    var shape: Shape
    var fill: Color = .clear
    var ringColor: Color = .gray.opacity(0.6)
    var ringLineWidth: CGFloat = 3
    var ringScale: CGFloat = 1.6
    var ringCount: Int = 2
    var duration: Double = 1.1
    var pressScale: CGFloat = 0.98
    var isActive: Bool = false
    var alsoPulseWhilePressed: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        PulsingButton(
            configuration: configuration,
            shape: shape,
            fill: fill,
            ringColor: ringColor,
            ringLineWidth: ringLineWidth,
            ringScale: ringScale,
            ringCount: ringCount,
            duration: duration,
            pressScale: pressScale,
            isActive: isActive,
            alsoPulseWhilePressed: alsoPulseWhilePressed
        )
    }

    private struct PulsingButton: View {
        let configuration: Configuration
        let shape: Shape
        let fill: Color
        let ringColor: Color
        let ringLineWidth: CGFloat
        let ringScale: CGFloat
        let ringCount: Int
        let duration: Double
        let pressScale: CGFloat
        let isActive: Bool
        let alsoPulseWhilePressed: Bool

        @State private var anim = false

        var pulsingNow: Bool {
            (alsoPulseWhilePressed && configuration.isPressed) || isActive
        }

        var body: some View {
            ZStack { content }
                .overlay(pulseOverlay)
                .scaleEffect(configuration.isPressed ? pressScale : 1)
                .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
                .onChange(of: pulsingNow) { oldValue, newValue in
                    anim = newValue
                }
                .onAppear {
                    anim = pulsingNow
                }
        }

        @ViewBuilder
        private var content: some View {
            switch shape {
            case .circle(let size):
                ZStack {
                    Circle().fill(fill)
                    configuration.label
                }
                .frame(width: size, height: size)
                .clipShape(Circle())

            case .rounded(let radius, let padding):
                configuration.label
                    .padding(padding)
                    .background(RoundedRectangle(cornerRadius: radius).fill(fill))
            }
        }

        @ViewBuilder
        private var pulseOverlay: some View {
            if pulsingNow {
                switch shape {
                case .circle(let size):
                    ZStack {
                        ForEach(0..<ringCount, id: \.self) { i in
                            Circle()
                                .stroke(ringColor, lineWidth: ringLineWidth)
                                .frame(width: size, height: size)
                                .scaleEffect(anim ? ringScale : 1)
                                .opacity(anim ? 0 : 1)
                                .animation(
                                    .easeOut(duration: duration)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(i) * (duration / Double(max(1, ringCount)))),
                                    value: anim
                                )
                        }
                    }

                case .rounded(let radius, _):
                    ZStack {
                        ForEach(0..<ringCount, id: \.self) { i in
                            RoundedRectangle(cornerRadius: radius)
                                .stroke(ringColor, lineWidth: ringLineWidth)
                                .scaleEffect(anim ? ringScale : 1)
                                .opacity(anim ? 0 : 1)
                                .animation(
                                    .easeOut(duration: duration)
                                        .repeatForever(autoreverses: false)
                                        .delay(Double(i) * (duration / Double(max(1, ringCount)))),
                                    value: anim
                                )
                        }
                    }
                }
            }
        }
    }
}
