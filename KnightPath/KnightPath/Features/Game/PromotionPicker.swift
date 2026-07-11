import SwiftUI
import ChessKit

struct PromotionPicker: View {
    let availablePieces: [String]
    let onSelect: (Piece.Kind) -> Void
    
    var body: some View {
        HStack(spacing: KPSpacing.sm) {
            ForEach(availablePieces, id: \.self) { pieceName in
                if let kind = pieceKind(from: pieceName) {
                    Button {
                        HapticsService.shared.move()
                        onSelect(kind)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: KPRadius.md)
                                .fill(KPColor.Background.base)
                                .frame(width: 60, height: 60)
                                .shadow(color: .black.opacity(0.2), radius: 4)
                            
                            Image(systemName: systemIcon(for: kind))
                                .font(.system(size: 30))
                                .foregroundColor(KPColor.Text.primary)
                        }
                    }
                }
            }
        }
        .padding(KPSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: KPRadius.xl)
                .fill(KPColor.Brand.primary)
                .shadow(color: .black.opacity(0.3), radius: 12)
        )
    }
    
    private func pieceKind(from name: String) -> Piece.Kind? {
        switch name.lowercased() {
        case "queen": return .queen
        case "rook": return .rook
        case "bishop": return .bishop
        case "knight": return .knight
        default: return nil
        }
    }
    
    private func systemIcon(for kind: Piece.Kind) -> String {
        switch kind {
        case .queen: return "crown"
        case .rook: return "building.columns.fill"
        case .bishop: return "triangle.fill"
        case .knight: return "star.fill"
        default: return "questionmark"
        }
    }
}

#Preview {
    PromotionPicker(availablePieces: ["queen", "rook", "bishop", "knight"]) { kind in
        print("Selected: \(kind)")
    }
    .padding()
    .background(KPColor.Background.soft)
}
