import Foundation

extension Consonant: HSBRepresentable {
    var hue: Double {
        switch place {
        case .bilabial: return 0.0.hueValue
        case .labiodental: return 30.0.hueValue
        case .dental: return 60.0.hueValue
        case .alveolar: return 90.0.hueValue
        case .postalveolar: return 120.0.hueValue
        case .retroflex: return 150.hueValue
        case .palatal: return 180.0.hueValue
        case .velar: return 210.0.hueValue
        case .uvular: return 240.hueValue
        case .pharyngeal: return 270.0.hueValue
        case .glottal: return 300.0.hueValue
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
