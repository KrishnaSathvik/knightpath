import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    let animationName: String
    let loopMode: LottieLoopMode
    let contentMode: UIView.ContentMode
    
    init(animationName: String, loopMode: LottieLoopMode = .playOnce, contentMode: UIView.ContentMode = .scaleAspectFit) {
        self.animationName = animationName
        self.loopMode = loopMode
        self.contentMode = contentMode
    }
    
    func makeUIView(context: Context) -> LottieAnimationView {
        let animationView = LottieAnimationView()
        animationView.contentMode = contentMode
        animationView.loopMode = loopMode
        
        // TODO: Load actual Lottie JSON files from bundle
        // For now, return empty view as placeholder
        // animationView.animation = LottieAnimation.named(animationName)
        // animationView.play()
        
        return animationView
    }
    
    func updateUIView(_ uiView: LottieAnimationView, context: Context) {
        // Animation updates handled by Lottie
    }
}

struct ConfettiBurstView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        if reduceMotion {
            // Static celebratory icon for Reduce Motion
            Image(systemName: "star.fill")
                .font(.system(size: 100))
                .foregroundColor(KPColor.Accent.gold)
                .transition(.scale)
        } else {
            // TODO: Replace with actual Lottie animation
            LottieView(animationName: "confetti-burst")
                .frame(width: 300, height: 300)
        }
    }
}

struct StarPopView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        if reduceMotion {
            Image(systemName: "star.fill")
                .font(.system(size: 50))
                .foregroundColor(KPColor.Accent.gold)
                .transition(.scale)
        } else {
            // TODO: Replace with actual Lottie animation
            LottieView(animationName: "star-pop")
                .frame(width: 100, height: 100)
        }
    }
}

struct LevelUpRingView: View {
    @Environment(\.accessibilityReduceMotion) var reduceMotion
    
    var body: some View {
        if reduceMotion {
            Circle()
                .stroke(KPColor.Brand.primary, lineWidth: 4)
                .frame(width: 100, height: 100)
                .transition(.scale)
        } else {
            // TODO: Replace with actual Lottie animation
            LottieView(animationName: "level-up-ring")
                .frame(width: 150, height: 150)
        }
    }
}

// TODO: Download free Lottie animations from LottieFiles.com:
// - confetti-burst.json (celebration)
// - star-pop.json (star reveal)
// - level-up-ring.json (XP ring completion)
// - coin-rain.json (chest opening)
// - flame.json (streak milestone)
//
// Add to Assets folder and load via LottieAnimation.named()
