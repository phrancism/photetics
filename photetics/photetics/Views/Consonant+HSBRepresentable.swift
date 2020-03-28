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

    var saturation: Double { isVoiced ? 0.5 : 0.75 }

    var brightness: Double {
        switch manner {
        case .plosive: return 0.9
        case .nasal: return 0.81
        case .trill: return 0.72
        case .flap: return 0.63
        case .fricative: return 0.54
        case .affricate: return 0.45
        case .lateralFricative: return 0.36
        case .approximant: return 0.27
        case .lateralApproximant: return 0.18
        }
    }
}
