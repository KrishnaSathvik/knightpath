import SwiftUI

struct SplashView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            KPColor.Background.soft
                .ignoresSafeArea()
            
            VStack(spacing: KPSpacing.xl) {
                Spacer()
                
                AssetPlaceholder("logo-shield", systemIcon: "crown.fill", size: 120)
                    .opacity(0)
                    .overlay(
                        Image(systemName: "crown.fill")
                            .font(.system(size: 120))
                            .foregroundColor(KPColor.Brand.primary)
                            .shadow(color: KPColor.Accent.gold.opacity(0.3), radius: 20)
                    )
                
                VStack(spacing: KPSpacing.sm) {
                    Text("KnightPath")
                        .font(KPFont.displayLarge())
                        .fontWeight(.bold)
                        .foregroundColor(KPColor.Text.primary)
                    
                    Text("Every move writes your story")
                        .font(KPFont.body())
                        .foregroundColor(KPColor.Text.secondary)
                }
                
                Spacer()
            }
        }
        .onAppear {
            Task {
                try? await Task.sleep(for: .seconds(1.2))
                withAnimation {
                    isPresented = false
                }
            }
        }
    }
}

#Preview {
    SplashView(isPresented: .constant(true))
}
