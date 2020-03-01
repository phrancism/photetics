import Foundation

protocol HSBRepresentable {
    var hue: Double { get }
    var saturation: Double { get }
    var brightness: Double { get }
}

extension Consonant: HSBRepresentable {
    var hue: Double {
        switch place {
        case .bilabial: return 0.0.hueValue
        case .labiodental: return 45.0.hueValue
        case .dental: return 90.0.hueValue
        case .alveolar: return 135.0.hueValue
        case .postalveolar: return 180.0.hueValue
        case .palatal: return 225.0.hueValue
        case .velar: return 270.0.hueValue
        case .glottal: return 315.0.hueValue
        default: return 1.0
        }
    }
        
    var saturation: Double {
        switch manner {
        case .plosive: return 0.9
        case .nasal: return 0.8
        case .trill: return 0.7
        case .flap: return 0.6
        case .fricative: return 0.5
        case .affricate: return 0.4
        case .lateralFricative: return 0.3
        case .approximant: return 0.2
        case .lateralApproximant: return 0.1
        }
    }
    
    var brightness: Double { isVoiced ? 0.5 : 0.6 }
}

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
    
    var saturation: Double { 1 }
    
    var brightness: Double {
        switch height {
        case .close: return 0.9
        case .nearClose: return 0.8
        case .closeMid: return 0.7
        case .mid: return 0.6
        case .openMid: return 0.5
        case .nearOpen: return 0.4
        case .open: return 0.3
        }
    }
}

fileprivate extension Double {
    var hueValue: Double { self / 360 }
}
