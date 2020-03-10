import Foundation

extension Vowel: HSBRepresentable {
    var hue: Double {
        let value: Double = {
            switch backness {
            case .front: return 0.0
            case .central: return 120.0
            case .back: return 240.0
            }
        }()
        
        guard isRounded else { return value.hueValue }
        
        return (value + 60.0).hueValue
    }
    
    var saturation: Double { 1.0 }
    
    var brightness: Double {
        switch height {
        case .close: return 0.90
        case .nearClose: return 0.85
        case .closeMid: return 0.80
        case .mid: return 0.75
        case .openMid: return 0.70
        case .nearOpen: return 0.65
        case .open: return 0.60
    } }
}
