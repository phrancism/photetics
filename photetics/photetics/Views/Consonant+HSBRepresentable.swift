import Foundation

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
    
    var brightness: Double { isVoiced ? 0.4 : 0.6 }
}
