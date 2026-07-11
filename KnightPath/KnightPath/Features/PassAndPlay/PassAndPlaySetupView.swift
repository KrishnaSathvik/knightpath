import SwiftUI

struct PassAndPlaySetupView: View {
    @State private var player1Name = "White"
    @State private var player2Name = "Black"
    @State private var selectedTimerIndex = 0
    @State private var flipBoard = true
    @State private var showGame = false
    
    private let timerOptions = ["None", "5 min", "10 min"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: KPSpacing.xl) {
                    VStack(alignment: .leading, spacing: KPSpacing.md) {
                        Text("Player Names")
                            .font(KPFont.bodyLarge())
                            .fontWeight(.semibold)
                            .foregroundColor(KPColor.Text.primary)
                        
                        KPCard(background: .white) {
                            VStack(spacing: KPSpacing.sm) {
                                HStack {
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: 24, height: 24)
                                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                                    
                                    TextField("White", text: $player1Name)
                                        .font(KPFont.body())
                                        .textFieldStyle(.plain)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Circle()
                                        .fill(Color.black)
                                        .frame(width: 24, height: 24)
                                    
                                    TextField("Black", text: $player2Name)
                                        .font(KPFont.body())
                                        .textFieldStyle(.plain)
                                }
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: KPSpacing.md) {
                        Text("Timer")
                            .font(KPFont.bodyLarge())
                            .fontWeight(.semibold)
                            .foregroundColor(KPColor.Text.primary)
                        
                        KPChip(options: timerOptions, selectedIndex: $selectedTimerIndex)
                    }
                    
                    VStack(alignment: .leading, spacing: KPSpacing.md) {
                        Text("Board Flip")
                            .font(KPFont.bodyLarge())
                            .fontWeight(.semibold)
                            .foregroundColor(KPColor.Text.primary)
                        
                        KPCard(background: .white) {
                            HStack {
                                VStack(alignment: .leading, spacing: KPSpacing.xxs) {
                                    Text("Flip board after each move")
                                        .font(KPFont.body())
                                        .foregroundColor(KPColor.Text.primary)
                                    
                                    Text("Privacy interstitial between turns")
                                        .font(KPFont.captionLarge())
                                        .foregroundColor(KPColor.Text.secondary)
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $flipBoard)
                                    .labelsHidden()
                                    .tint(KPColor.Brand.primary)
                            }
                        }
                    }
                    
                    KPButton("Start Game", style: .primary) {
                        showGame = true
                    }
                    .padding(.top, KPSpacing.lg)
                }
                .padding()
            }
            .background(KPColor.Background.soft)
            .navigationTitle("Pass & Play")
            .navigationDestination(isPresented: $showGame) {
                PassAndPlayGameView(
                    player1Name: player1Name,
                    player2Name: player2Name,
                    flipBoard: flipBoard
                )
            }
        }
    }
}

#Preview {
    PassAndPlaySetupView()
}
