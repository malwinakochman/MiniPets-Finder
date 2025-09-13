import SwiftUI

struct SplashView: View {
    @Binding var showSplash: Bool
    @State private var animateLogo = false
    @State private var showStars = false
    @State private var starOpacities: [Double] = [0, 0, 0]

    var body: some View {
        ZStack {
            // Blurry background
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .ignoresSafeArea()

            VStack {
                Spacer()
                ZStack {
                    // App icon with pop animation
                    Image("icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: animateLogo ? 160 : 60, height: animateLogo ? 160 : 60)
                        .clipShape(RoundedRectangle(cornerRadius: 40, style: .continuous))
                        .shadow(color: Color(hex: "#cbb1cd").opacity(0.5), radius: 24, x: 0, y: 12)
                        .scaleEffect(animateLogo ? 1.0 : 0.7)
                        .opacity(animateLogo ? 1 : 0.7)
                        .animation(.spring(response: 0.7, dampingFraction: 0.6), value: animateLogo)
                    // Stars in different places
                    if showStars {
                        // Top left
                        Image(systemName: "sparkle")
                            .font(.system(size: 38))
                            .foregroundColor(Color(hex: "#fff174").opacity(starOpacities[0]))
                            .shadow(color: Color(hex: "#fff174").opacity(0.7), radius: 8, x: 0, y: 0)
                            .opacity(starOpacities[0])
                            .offset(x: -80, y: -90)
                            .animation(.easeInOut(duration: 0.5).delay(0.3), value: starOpacities[0])
                        // Top right
                        Image(systemName: "sparkle")
                            .font(.system(size: 38))
                            .foregroundColor(Color(hex: "#fff174").opacity(starOpacities[1]))
                            .shadow(color: Color(hex: "#fff174").opacity(0.7), radius: 8, x: 0, y: 0)
                            .opacity(starOpacities[1])
                            .offset(x: 90, y: -70)
                            .animation(.easeInOut(duration: 0.5).delay(0.48), value: starOpacities[1])
                        // Bottom left
                        Image(systemName: "sparkle")
                            .font(.system(size: 32))
                            .foregroundColor(Color(hex: "#fff174").opacity(starOpacities[2]))
                            .shadow(color: Color(hex: "#fff174").opacity(0.7), radius: 7, x: 0, y: 0)
                            .opacity(starOpacities[2])
                            .offset(x: -60, y: 80)
                            .animation(.easeInOut(duration: 0.5).delay(0.65), value: starOpacities[2])
                    }
                }
                Spacer()
            }
        }
        .onAppear {
            animateLogo = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                showStars = true
                for i in 0..<3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15 * Double(i)) {
                        starOpacities[i] = 1
                    }
                }
                // Hide splash after a shorter animation to show permissions faster
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation {
                        showSplash = false
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    func starOffset(index: Int) -> CGSize {
        switch index {
        case 0:
            return CGSize(width: -60, height: -60)
        case 1:
            return CGSize(width: 60, height: -60)
        case 2:
            return CGSize(width: 0, height: -90)
        default:
            return .zero
        }
    }

    // Add a helper for non-regular blink delays
    func starBlinkDelay(index: Int) -> Double {
        switch index {
        case 0: return 0.22
        case 1: return 0.44
        case 2: return 0.31
        default: return 0.2
        }
    }
}

// VisualEffectBlur for iOS 15+
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
