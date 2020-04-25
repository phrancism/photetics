import Foundation

extension Vowel: HSBRepresentable {
    var hue: Double { 330.hueValue }

    var saturation: Double {
        switch backness {
        case .front: return 0.33
        case .central: return 0.67
        case .back: return 1.0
        }
    }

    var brightness: Double {
        switch height {
        case .close: return 0.9
        case .nearClose: return 0.81
        case .closeMid: return 0.72
        case .mid: return 0.63
        case .openMid: return 0.54
        case .nearOpen: return 0.45
        case .open: return 0.36
        }
    }
}
