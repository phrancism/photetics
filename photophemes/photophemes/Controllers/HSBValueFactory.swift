import Foundation

struct HSBValueFactory {
    static func createValues(for phoneme: Phoneme, language: Language)
        -> (hue: Double, saturation: Double, brightness: Double) {
        
            var hue: Double = 0.0
            var saturation: Double = 0.0
            var brightness: Double = 0.0
            
            if let consonant = phoneme as? Consonant {
                hue = HSBValueFactory.hue(consonant: consonant, language: language)
                saturation = consonant.isVoiced ? 0.5 : 0.9
                brightness = HSBValueFactory.brightness(consonant: consonant, language: language)
            } else if let vowel = phoneme as? Vowel {
                hue = vowel.hue
                saturation = vowel.saturation
                brightness = vowel.brightness
            }
            
            return (hue, saturation, brightness)
    }
        
    private static func hue(consonant: Consonant, language: Language) -> Double {
        switch language {
        case .english:
            switch consonant.place {
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
        case .italian:
            switch consonant.place {
            case .bilabial: return 0.0
            case .labiodental: return 60.hueValue
            case .alveolar: return 120.hueValue
            case .postalveolar: return 180.0.hueValue
            case .palatal: return 240.hueValue
            case .velar: return 300.hueValue
            default: return 1.0
            }
        case .tagalog:
            switch consonant.place {
            case .bilabial: return 0.0
            case .alveolar: return 60.0.hueValue
            case .postalveolar: return 120.0.hueValue
            case .palatal: return 180.0.hueValue
            case .velar: return 240.0.hueValue
            case .glottal: return 300.0.hueValue
            default: return 1.0
            }
        }
    }
    private static func brightness(consonant: Consonant, language: Language) -> Double {
        switch language {
        case .english:
            switch consonant.manner {
            case .plosive: return 0.4
            case .nasal: return 0.5
            case .fricative: return 0.6
            case .affricate: return 0.7
            case .approximant: return 0.8
            case .lateralApproximant: return 0.9
            default: return 0.0
            }
        case .italian, .tagalog:
            switch consonant.manner {
            case .plosive: return 0.3
            case .nasal: return 0.4
            case .trill, .flap: return 0.5
            case .fricative: return 0.6
            case .affricate: return 0.7
            case .approximant: return 0.8
            case .lateralApproximant: return 90.0.hueValue
            default: return 1.0
            }
        }
    }
}

extension Vowel {
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
