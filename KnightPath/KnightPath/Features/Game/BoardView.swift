import SwiftUI
import ChessKit

struct BoardView: View {
    @Bindable var viewModel: GameViewModel
    
    @State private var draggedPiece: (square: Square, piece: Piece)?
    @State private var dragOffset: CGSize = .zero
    
    private let ranks = Array((1...8).reversed())
    private let files = ["a", "b", "c", "d", "e", "f", "g", "h"]
    
    var body: some View {
        GeometryReader { geometry in
            let squareSize = min(geometry.size.width, geometry.size.height) / 8
            let boardSize = squareSize * 8
            
            ZStack {
                VStack(spacing: 0) {
                    ForEach(ranks, id: \.self) { rank in
                        HStack(spacing: 0) {
                            ForEach(files, id: \.self) { file in
                                if let square = Square("\(file)\(rank)") {
                                    SquareView(
                                        square: square,
                                        piece: viewModel.gameState.piece(at: square),
                                        isSelected: viewModel.selectedSquare == square,
                                        isLegalMove: viewModel.legalMoves.contains(square),
                                        isLastMove: isLastMoveSquare(square),
                                        isCheck: isCheckSquare(square),
                                        squareSize: squareSize
                                    )
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(squareAccessibilityLabel(square: square))
                                    .accessibilityHint(squareAccessibilityHint(square: square))
                                    .accessibilityAddTraits(viewModel.legalMoves.contains(square) ? .isButton : [])
                                    .onTapGesture {
                                        viewModel.selectSquare(square)
                                    }
                                    .gesture(
                                        DragGesture(minimumDistance: 0)
                                            .onChanged { value in
                                                handleDragChanged(square: square, value: value)
                                            }
                                            .onEnded { value in
                                                handleDragEnded(value: value, squareSize: squareSize, boardOrigin: CGPoint(x: (geometry.size.width - boardSize) / 2, y: (geometry.size.height - boardSize) / 2))
                                            }
                                    )
                                }
                            }
                        }
                    }
                }
                .frame(width: boardSize, height: boardSize)
                
                coordinateLabels(squareSize: squareSize, boardSize: boardSize)
                
                if let dragged = draggedPiece {
                    PieceView(piece: dragged.piece, size: squareSize * 0.9)
                        .offset(dragOffset)
                        .scaleEffect(1.2)
                        .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                        .allowsHitTesting(false)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .aspectRatio(1, contentMode: .fit)
        .background(KPColor.Background.base)
    }
    
    private func coordinateLabels(squareSize: CGFloat, boardSize: CGFloat) -> some View {
        ZStack {
            VStack {
                ForEach(ranks, id: \.self) { rank in
                    Text("\(rank)")
                        .font(KPFont.captionSmall())
                        .foregroundColor(KPColor.Text.secondary)
                        .frame(height: squareSize)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 4)
            
            HStack {
                ForEach(files, id: \.self) { file in
                    Text(file)
                        .font(KPFont.captionSmall())
                        .foregroundColor(KPColor.Text.secondary)
                        .frame(width: squareSize)
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, 4)
        }
    }
    
    private func isLastMoveSquare(_ square: Square) -> Bool {
        guard let lastMove = viewModel.lastMove else { return false }
        return square == lastMove.from || square == lastMove.to
    }
    
    private func isCheckSquare(_ square: Square) -> Bool {
        guard viewModel.gameState.isCheck else { return false }
        guard let piece = viewModel.gameState.piece(at: square) else { return false }
        return piece.kind == .king && piece.color == (viewModel.gameState.currentPlayer == .white ? .white : .black)
    }
    
    private func handleDragChanged(square: Square, value: DragGesture.Value) {
        guard let piece = viewModel.gameState.piece(at: square),
              piece.color == (viewModel.gameState.currentPlayer == .white ? .white : .black) else {
            return
        }
        
        if draggedPiece == nil {
            draggedPiece = (square, piece)
            viewModel.selectSquare(square)
        }
        
        dragOffset = value.translation
    }
    
    private func handleDragEnded(value: DragGesture.Value, squareSize: CGFloat, boardOrigin: CGPoint) {
        guard let dragged = draggedPiece else { return }
        
        let dragLocation = CGPoint(
            x: boardOrigin.x + value.location.x,
            y: boardOrigin.y + value.location.y
        )
        
        let file = Int(dragLocation.x / squareSize)
        let rank = 8 - Int(dragLocation.y / squareSize)
        
        if file >= 0 && file < 8 && rank >= 1 && rank <= 8 {
            let fileStr = files[file]
            if let targetSquare = Square("\(fileStr)\(rank)") {
                viewModel.attemptMove(from: dragged.square, to: targetSquare)
            }
        }
        
        draggedPiece = nil
        dragOffset = .zero
    }
}

struct SquareView: View {
    let square: Square
    let piece: Piece?
    let isSelected: Bool
    let isLegalMove: Bool
    let isLastMove: Bool
    let isCheck: Bool
    let squareSize: CGFloat
    
    private var isDark: Bool {
        let file = square.file.rawValue
        let rank = square.rank.rawValue
        return (file + rank) % 2 == 0
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(squareColor)
                .frame(width: squareSize, height: squareSize)
            
            if isLastMove {
                Rectangle()
                    .fill(Color.yellow.opacity(0.35))
                    .frame(width: squareSize, height: squareSize)
            }
            
            if isCheck {
                Rectangle()
                    .fill(KPColor.danger.opacity(0.4))
                    .frame(width: squareSize, height: squareSize)
                    .overlay(
                        Circle()
                            .stroke(KPColor.danger, lineWidth: 3)
                            .scaleEffect(0.9)
                            .opacity(0.8)
                    )
            }
            
            if let piece = piece {
                PieceView(piece: piece, size: squareSize * 0.9)
                    .scaleEffect(isSelected ? 1.08 : 1.0)
                    .shadow(color: isSelected ? KPColor.Brand.primary.opacity(0.6) : .clear, radius: 12)
            }
            
            if isLegalMove {
                if piece != nil {
                    Circle()
                        .stroke(KPColor.Accent.gold, lineWidth: 3)
                        .frame(width: squareSize * 0.8, height: squareSize * 0.8)
                } else {
                    Circle()
                        .fill(KPColor.Brand.primary.opacity(0.7))
                        .frame(width: squareSize * 0.3, height: squareSize * 0.3)
                }
            }
        }
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var squareColor: Color {
        isDark ? KPColor.Board.dark : KPColor.Board.light
    }
    
    private var accessibilityLabel: String {
        var label = square.description
        if let piece = piece {
            let colorStr = piece.color == .white ? "White" : "Black"
            let kindStr: String
            switch piece.kind {
            case .king: kindStr = "king"
            case .queen: kindStr = "queen"
            case .rook: kindStr = "rook"
            case .bishop: kindStr = "bishop"
            case .knight: kindStr = "knight"
            case .pawn: kindStr = "pawn"
            }
            label = "\(colorStr) \(kindStr), \(square.description)"
        } else {
            label = "\(square.description), empty"
        }
        if isSelected {
            label += ", selected"
        }
        if isLegalMove {
            label += ", legal move"
        }
        return label
    }
}

struct PieceView: View {
    let piece: Piece
    let size: CGFloat
    
    var body: some View {
        AssetPlaceholder(
            assetName,
            systemIcon: systemIcon,
            size: size
        )
    }
    
    private var assetName: String {
        let colorPrefix = piece.color == .white ? "w" : "b"
        let kindName = kindString(piece.kind)
        return "piece-\(colorPrefix)-\(kindName)"
    }
    
    private var systemIcon: String {
        switch piece.kind {
        case .king:
            return "crown.fill"
        case .queen:
            return "crown"
        case .rook:
            return "building.columns.fill"
        case .bishop:
            return "triangle.fill"
        case .knight:
            return "star.fill"
        case .pawn:
            return "circle.fill"
        }
    }
    
    private func kindString(_ kind: Piece.Kind) -> String {
        switch kind {
        case .king: return "king"
        case .queen: return "queen"
        case .rook: return "rook"
        case .bishop: return "bishop"
        case .knight: return "knight"
        case .pawn: return "pawn"
        }
    }
}

#Preview("Board with Game") {
    struct BoardPreview: View {
        @State private var viewModel = GameViewModel()
        
        var body: some View {
            VStack {
                Text("Current Player: \(viewModel.gameState.currentPlayer.rawValue.capitalized)")
                    .font(KPFont.body())
                    .foregroundColor(KPColor.Text.primary)
                    .padding()
                
                BoardView(viewModel: viewModel)
                    .padding()
                
                HStack {
                    KPButton("Reset", style: .secondary) {
                        viewModel.reset()
                    }
                    
                    KPButton("Resign", style: .primary) {
                        viewModel.resign()
                    }
                }
                .padding()
            }
            .background(KPColor.Background.soft)
        }
    }
    
    return BoardPreview()
}
