import SwiftUI

enum KPFont {
    static func display(_ size: CGFloat = 28) -> Font {
        .system(size: size, weight: .bold, design: .rounded)
    }
    
    static func body(_ size: CGFloat = 16) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    
    static func caption(_ size: CGFloat = 13) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
    
    static func displayLarge() -> Font {
        display(34)
    }
    
    static func displayMedium() -> Font {
        display(28)
    }
    
    static func displaySmall() -> Font {
        display(22)
    }
    
    static func bodyLarge() -> Font {
        body(18)
    }
    
    static func bodyMedium() -> Font {
        body(16)
    }
    
    static func bodySmall() -> Font {
        body(14)
    }
    
    static func captionLarge() -> Font {
        caption(13)
    }
    
    static func captionSmall() -> Font {
        caption(11)
    }
}
