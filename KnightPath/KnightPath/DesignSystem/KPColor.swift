import SwiftUI

enum KPColor {
    enum Background {
        static let base = Color(hex: "#FFFFFF")
        static let soft = Color(hex: "#F7F4FF")
    }
    
    enum Card {
        static let border = Color(hex: "#E5E0F0")
    }
    
    enum Brand {
        static let primary = Color(hex: "#7C3AED")
        static let dark = Color(hex: "#5B21B6")
    }
    
    enum Accent {
        static let gold = Color(hex: "#F5A623")
    }
    
    static let success = Color(hex: "#58CC02")
    static let danger = Color(hex: "#FF4B4B")
    static let streak = Color(hex: "#FF9600")
    
    enum Text {
        static let primary = Color(hex: "#3C3654")
        static let secondary = Color(hex: "#8B84A3")
    }
    
    enum Board {
        static let dark = Color(hex: "#779952")
        static let light = Color(hex: "#EDEED1")
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
